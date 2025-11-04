require 'rails_helper'

RSpec.describe "/projects/:project_id/stories/:story_id/comments", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:story) { create(:story, board: board) }

  let(:org_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:comment_by_org_owner) { create(:comment, story: story, user: org_owner) }
  let!(:comment_by_project_member) { create(:comment, story: story, user: project_member) }

  let(:valid_attributes) { { content: "This is a valid comment." } }
  let(:invalid_attributes) { { content: "" } }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:organization_user, organization: organization, user: project_owner, role: :member)
    create(:organization_user, organization: organization, user: project_member, role: :member)
    create(:organization_user, organization: organization, user: project_guest, role: :member)
    create(:project_user, project: project, user: project_owner, role: :owner)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  describe "as organization owner" do
    before { sign_in org_owner }

    it "can create comments" do
      expect {
        post project_story_comments_url(project, story), params: { comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it "can edit their own comments" do
      patch project_story_comment_url(project, story, comment_by_org_owner), params: { comment: { content: "Updated" } }
      comment_by_org_owner.reload
      expect(comment_by_org_owner.content.to_plain_text).to eq("Updated")
    end

    it "cannot edit other's comments" do
      expect {
        patch project_story_comment_url(project, story, comment_by_project_member), params: { comment: { content: "Updated" } }
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "can delete their own comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_org_owner)
      }.to change(Comment, :count).by(-1)
    end

    it "cannot delete other's comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_project_member)
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "as project owner" do
    before { sign_in project_owner }

    it "can create comments" do
      expect {
        post project_story_comments_url(project, story), params: { comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it "can edit their own comments" do
      comment = create(:comment, story: story, user: project_owner)
      patch project_story_comment_url(project, story, comment), params: { comment: { content: "Updated" } }
      comment.reload
      expect(comment.content.to_plain_text).to eq("Updated")
    end

    it "cannot edit other's comments" do
      expect {
        patch project_story_comment_url(project, story, comment_by_project_member), params: { comment: { content: "Updated" } }
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "can delete their own comments" do
      comment = create(:comment, story: story, user: project_owner)
      expect {
        delete project_story_comment_url(project, story, comment)
      }.to change(Comment, :count).by(-1)
    end

    it "cannot delete other's comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_project_member)
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "as project member" do
    before { sign_in project_member }

    it "can create comments" do
      expect {
        post project_story_comments_url(project, story), params: { comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it "can edit their own comments" do
      patch project_story_comment_url(project, story, comment_by_project_member), params: { comment: { content: "Updated" } }
      comment_by_project_member.reload
      expect(comment_by_project_member.content.to_plain_text).to eq("Updated")
    end

    it "cannot edit other's comments" do
      expect {
        patch project_story_comment_url(project, story, comment_by_org_owner), params: { comment: { content: "Updated" } }
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "can delete their own comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_project_member)
      }.to change(Comment, :count).by(-1)
    end

    it "cannot delete other's comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_org_owner)
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "as project guest" do
    before { sign_in project_guest }

    it "can create comments" do
      expect {
        post project_story_comments_url(project, story), params: { comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it "can edit their own comments" do
      comment = create(:comment, story: story, user: project_guest)
      patch project_story_comment_url(project, story, comment), params: { comment: { content: "Updated" } }
      comment.reload
      expect(comment.content.to_plain_text).to eq("Updated")
    end

    it "cannot edit other's comments" do
      expect {
        patch project_story_comment_url(project, story, comment_by_project_member), params: { comment: { content: "Updated" } }
      }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "can delete their own comments" do
      comment = create(:comment, story: story, user: project_guest)
      expect {
        delete project_story_comment_url(project, story, comment)
      }.to change(Comment, :count).by(-1)
    end

    it "cannot delete other's comments" do
      expect {
        delete project_story_comment_url(project, story, comment_by_project_member)
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe "as an unrelated user" do
    before { sign_in other_user }

    it "is forbidden to access new" do
      get new_project_story_comment_url(project, story)
      expect(response).to have_http_status(404)
    end

    it "is forbidden to access create" do
      post project_story_comments_url(project, story), params: { comment: valid_attributes }
      expect(response).to have_http_status(404)
    end
  end

  describe "when not authenticated" do
    it "redirects from new to the login page" do
      get new_project_story_comment_url(project, story)
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
