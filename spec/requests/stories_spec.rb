require 'rails_helper'

RSpec.describe "/projects/:project_id/stories", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:board) { create(:board, project: project) }

  let(:valid_attributes) do
    {
      board_id: board.id,
      title: 'Valid Title',
      description: 'Valid Description'
    }
  end

  let(:invalid_attributes) do
    {
      board_id: board.id,
      title: nil
    }
  end

  let!(:story) { create(:story, valid_attributes) }

  before(:each) do
    sign_in(user)
    create(:project_user, project: project, user: user)
  end

  describe "GET /show" do
    it "renders a successful response" do
      get project_story_url(project, story)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_project_story_url(project, board_id: board.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Story" do
        expect do
          post project_stories_url(project), params: { story: valid_attributes }
        end.to change(Story, :count).by(1)
      end

      it "redirects to the created story" do
        post project_stories_url(project), params: { story: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="update" target="modal">')
        expect(response.body).to include("<turbo-stream action=\"append\" target=\"flash-container\">")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Story" do
        expect do
          post project_stories_url(project), params: { story: invalid_attributes }
        end.to change(Story, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post project_stories_url(project), params: { story: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { title: 'New Valid Title' }
      end

      it "updates the requested story" do
        patch project_story_url(project, story), params: { story: new_attributes }
        story.reload
        expect(story.title).to eq('New Valid Title')
      end

      it "return turbo-stream tags" do
        patch project_story_url(project, story), params: { story: new_attributes }
        story.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="update" target="modal">')
        expect(response.body).to include("<turbo-stream action=\"append\" target=\"flash-container\">")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch project_story_url(project, story), params: { story: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested story" do
      expect do
        delete project_story_url(project, story)
      end.to change(Story, :count).by(-1)
    end

    it "renders turbo-stream tags" do
      delete project_story_url(project, story)
      expect(response.body).to include("<turbo-stream action=\"append\" target=\"flash-container\">")
    end
  end

  describe "PATCH /move" do
    let(:board2) { create(:board, project: project) }
    let!(:story2) { create(:story, board: board2) }

    it "renders a successful response" do
      expect(story.position).to eq(1)
      expect(story.board).to eq(board)
      expect(story2.position).to eq(1)
      patch move_project_story_url(project, story), params: { story: { board_id: board2.id, position: 1 } }
      story.reload; story2.reload
      expect(story.position).to eq(1)
      expect(story.board).to eq(board2)
      expect(story2.position).to eq(2)
      expect(response).to be_successful
    end
  end
end
