require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validation" do
    it { should validate_presence_of(:content) }

    describe "#user_must_be_organization_owner_or_project_member" do
      let(:organization) { create(:organization) }
      let(:project) { create(:project, organization: organization) }
      let(:board) { create(:board, project: project) }
      let(:story_owner) { create(:user) }

      let(:org_owner) { create(:user) }
      let(:project_member) { create(:user) }
      let(:org_member) { create(:user) }
      let(:unrelated_user) { create(:user) }

      before do
        create(:organization_user, organization: organization, user: org_owner, role: :owner)
        create(:organization_user, organization: organization, user: org_member, role: :member)
        create(:organization_user, organization: organization, user: story_owner, role: :member)
        create(:organization_user, organization: organization, user: project_member, role: :member)
        create(:project_user, project: project, user: story_owner, role: :member)
        create(:project_user, project: project, user: project_member, role: :member)
      end

      let(:story) { create(:story, board: board, owner: story_owner) }

      it "is valid when user is an organization owner" do
        comment = build(:comment, story: story, user: org_owner)
        expect(comment).to be_valid
      end

      it "is valid when user is a project member" do
        comment = build(:comment, story: story, user: project_member)
        expect(comment).to be_valid
      end

      it "is invalid when user is just an organization member" do
        comment = build(:comment, story: story, user: org_member)
        expect(comment).not_to be_valid
        expect(comment.errors[:user]).to include("must be an organization owner or a project member to comment")
      end

      it "is invalid when user is unrelated" do
        comment = build(:comment, story: story, user: unrelated_user)
        expect(comment).not_to be_valid
        expect(comment.errors[:user]).to include("must be an organization owner or a project member to comment")
      end
    end
  end

  describe "broadcasts" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:board) { create(:board, project: project) }
    let(:user) { create(:user) }
    before do
      create(:organization_user, organization: organization, user: user, role: :owner)
      create(:project_user, project: project, user: user, role: :member)
    end
    let(:story) { create(:story, board: board, owner: user) }
    let!(:comment) { create(:comment, story: story, user: user) }


    it "enqueues a broadcast job on create" do
      new_comment = build(:comment, story: story, user: user)
      expect { new_comment.save! }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
    end

    it "enqueues a broadcast job on update" do
      expect { comment.update!(content: "updated content") }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
    end

    it "triggers a broadcast on destroy" do
      expect(comment).to receive(:broadcast_destroy)
      comment.destroy!
    end
  end
end
