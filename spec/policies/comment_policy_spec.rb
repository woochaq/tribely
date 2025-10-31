require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  subject { described_class }

  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:story) { create(:story, board: board) }

  let(:org_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:other_user) { create(:user) }

  let(:comment_by_org_owner) { create(:comment, story: story, user: org_owner) }
  let(:comment_by_project_owner) { create(:comment, story: story, user: project_owner) }
  let(:comment_by_project_member) { create(:comment, story: story, user: project_member) }
  let(:comment_by_project_guest) { create(:comment, story: story, user: project_guest) }
  let(:comment_by_other_user) { create(:comment, story: story, user: other_user) }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:project_user, project: project, user: project_owner, role: :owner)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  permissions :show? do
    it "grants access to everyone" do
      expect(subject).to permit(org_owner, comment_by_org_owner)
      expect(subject).to permit(project_owner, comment_by_project_owner)
      expect(subject).to permit(project_member, comment_by_project_member)
      expect(subject).to permit(project_guest, comment_by_project_guest)
      expect(subject).to permit(other_user, comment_by_other_user)
    end
  end

  permissions :new?, :create? do
    it "grants access to the organization owner" do
      expect(subject).to permit(org_owner, Comment.new(story: story))
    end

    it "grants access to the project owner" do
      expect(subject).to permit(project_owner, Comment.new(story: story))
    end

    it "grants access to the project member" do
      expect(subject).to permit(project_member, Comment.new(story: story))
    end

    it "grants access to the project guest" do
      expect(subject).to permit(project_guest, Comment.new(story: story))
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, Comment.new(story: story))
    end
  end

  permissions :edit?, :update?, :destroy? do
    context "when the user is the author of the comment" do
      it "grants access to the organization owner for their own comment" do
        expect(subject).to permit(org_owner, comment_by_org_owner)
      end

      it "grants access to the project owner for their own comment" do
        expect(subject).to permit(project_owner, comment_by_project_owner)
      end

      it "grants access to the project member for their own comment" do
        expect(subject).to permit(project_member, comment_by_project_member)
      end

      it "grants access to the project guest for their own comment" do
        expect(subject).to permit(project_guest, comment_by_project_guest)
      end
    end

    context "when the user is not the author of the comment" do
      it "denies access to the organization owner for another user's comment" do
        expect(subject).not_to permit(org_owner, comment_by_project_owner)
      end

      it "denies access to the project owner for another user's comment" do
        expect(subject).not_to permit(project_owner, comment_by_project_member)
      end

      it "denies access to the project member for another user's comment" do
        expect(subject).not_to permit(project_member, comment_by_project_owner)
      end

      it "denies access to the project guest for another user's comment" do
        expect(subject).not_to permit(project_guest, comment_by_project_owner)
      end

      it "denies access to an unrelated user for any comment" do
        expect(subject).not_to permit(other_user, comment_by_org_owner)
      end
    end
  end

  describe "Scope" do
    let(:user_with_comments) { create(:user) }
    let(:story_with_comments) { create(:story, board: board) }
    let!(:comment1) { create(:comment, story: story_with_comments, user: user_with_comments) }
    let!(:comment2) { create(:comment, story: story_with_comments, user: other_user) }

    it "resolves all comments" do
      scope = described_class::Scope.new(user_with_comments, Comment.all).resolve
      expect(scope).to contain_exactly(comment1, comment2)
    end
  end

  describe "permitted_attributes" do
    it "returns the content attribute for any user" do
      policy = described_class.new(other_user, comment_by_other_user)
      expect(policy.permitted_attributes).to contain_exactly(:content)
    end
  end
end
