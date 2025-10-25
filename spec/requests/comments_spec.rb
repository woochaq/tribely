require 'rails_helper'

RSpec.describe "/projects/:project_id/stories/:story_id/comments", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:board) { create(:board, project: project) }
  let(:story) { create(:story, board: board) }
  let(:comment) { create(:comment, story: story, user: user) }
  let(:other_user) { create(:user) }
  let(:other_comment) { create(:comment, story: story, user: other_user) }

  let(:valid_attributes) do
    { content: 'This is a valid comment.' }
  end

  let(:invalid_attributes) do
    { content: nil }
  end

  before(:each) do
    create(:project_user, project: project, user: user)
    sign_in(user)
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_project_story_comment_url(project, story), as: :turbo_stream
      expect(response).to be_successful
      expect(response.body).to include("turbo-frame id=\"new_comment_form_story_#{story.id}\"")
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Comment" do
        expect do
          post project_story_comments_url(project, story), params: { comment: valid_attributes }, as: :turbo_stream
        end.to change(Comment, :count).by(1)
      end

      it "returns a turbo_stream response" do
        post project_story_comments_url(project, story), params: { comment: valid_attributes }, as: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response.body).to include("<turbo-stream action=\"prepend\" target=\"comments_story_#{story.id}\">")
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"new_comment_form_story_#{story.id}\">")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect do
          post project_story_comments_url(project, story), params: { comment: invalid_attributes }, as: :turbo_stream
        end.to change(Comment, :count).by(0)
      end

      it "renders a response with 422 status" do
        post project_story_comments_url(project, story), params: { comment: invalid_attributes }, as: :turbo_stream
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /edit" do
    it "renders a successful response for the comment author" do
      get edit_project_story_comment_url(project, story, comment)
      expect(response).to be_successful
      expect(response.body).to include("turbo-frame id=\"comment_#{comment.id}\"")
    end

    it "is forbidden for another user" do
      sign_in(other_user)
      get edit_project_story_comment_url(project, story, other_comment)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { content: 'This is an updated comment.' }
      end

      it "updates the requested comment" do
        patch project_story_comment_url(project, story, comment), params: { comment: new_attributes }, as: :turbo_stream
        comment.reload
        expect(comment.content.to_plain_text).to eq('This is an updated comment.')
      end

      it "returns a turbo_stream response" do
        patch project_story_comment_url(project, story, comment), params: { comment: new_attributes }, as: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"comment_#{comment.id}\">")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        patch project_story_comment_url(project, story, comment), params: { comment: invalid_attributes }, as: :turbo_stream
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested comment" do
      comment # ensure comment is created
      expect do
        delete project_story_comment_url(project, story, comment), as: :turbo_stream
      end.to change(Comment, :count).by(-1)
    end

    it "returns a turbo_stream response" do
      delete project_story_comment_url(project, story, comment), as: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response.body).to include("<turbo-stream action=\"remove\" target=\"comment_#{comment.id}\"")
    end

    it "is forbidden for another user" do
      sign_in(other_user)
      other_comment # ensure other_comment is created
      delete project_story_comment_url(project, story, other_comment), as: :turbo_stream
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /show" do
    it "renders a successful response for the comment author" do
      get project_story_comment_url(project, story, comment)
      expect(response).to be_successful
      expect(response.body).to include("turbo-frame id=\"comment_#{comment.id}\"")
    end

    it "is forbidden for another user" do
      sign_in(other_user)
      get project_story_comment_url(project, story, other_comment)
      expect(response).to have_http_status(:not_found)
    end
  end
end
