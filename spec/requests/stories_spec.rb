require 'rails_helper'

RSpec.describe "/projects/:project_id/stories", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:story) { create(:story, board: board) }

  let(:org_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:project_user, project: project, user: project_owner, role: :owner)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  let(:valid_attributes) { { board_id: board.id, title: "New Story" } }
  let(:invalid_attributes) { { title: "" } }

  describe "as organization owner" do
    before { sign_in org_owner }

    describe "GET /show" do
      it "succeeds" do
        get project_story_url(project, story)
        expect(response).to be_successful
      end
    end

    describe "GET /new" do
      it "succeeds" do
        get new_project_story_url(project, board_id: board.id)
        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      it "creates a new Story" do
        expect {
          post project_stories_url(project), params: { story: valid_attributes }
        }.to change(Story, :count).by(1)
      end
    end

    describe "PATCH /update" do
      it "updates the requested story" do
        patch project_story_url(project, story), params: { story: { title: "Updated Title" } }
        story.reload
        expect(story.title).to eq("Updated Title")
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested story" do
        story_to_delete = create(:story, board: board)
        expect {
          delete project_story_url(project, story_to_delete)
        }.to change(Story, :count).by(-1)
      end
    end

    describe "PATCH /move" do
      it "moves the story" do
        other_board = create(:board, project: project)
        patch move_project_story_url(project, story), params: { story: { board_id: other_board.id, position: 1 } }
        story.reload
        expect(story.board).to eq(other_board)
      end
    end
  end

  describe "as project owner" do
    before { sign_in project_owner }

    describe "GET /show" do
      it "succeeds" do
        get project_story_url(project, story)
        expect(response).to be_successful
      end
    end

    describe "GET /new" do
      it "succeeds" do
        get new_project_story_url(project, board_id: board.id)
        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      it "creates a new Story" do
        expect {
          post project_stories_url(project), params: { story: valid_attributes }
        }.to change(Story, :count).by(1)
      end
    end

    describe "PATCH /update" do
      it "updates the requested story" do
        patch project_story_url(project, story), params: { story: { title: "Updated Title" } }
        story.reload
        expect(story.title).to eq("Updated Title")
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested story" do
        story_to_delete = create(:story, board: board)
        expect {
          delete project_story_url(project, story_to_delete)
        }.to change(Story, :count).by(-1)
      end
    end

    describe "PATCH /move" do
      it "moves the story" do
        other_board = create(:board, project: project)
        patch move_project_story_url(project, story), params: { story: { board_id: other_board.id, position: 1 } }
        story.reload
        expect(story.board).to eq(other_board)
      end
    end
  end

  describe "as project member" do
    before { sign_in project_member }

    describe "GET /show" do
      it "succeeds" do
        get project_story_url(project, story)
        expect(response).to be_successful
      end
    end

    describe "GET /new" do
      it "succeeds" do
        get new_project_story_url(project, board_id: board.id)
        expect(response).to be_successful
      end
    end

    describe "POST /create" do
      it "creates a new Story" do
        expect {
          post project_stories_url(project), params: { story: valid_attributes }
        }.to change(Story, :count).by(1)
      end
    end

    describe "PATCH /update" do
      it "updates the requested story" do
        patch project_story_url(project, story), params: { story: { title: "Updated Title" } }
        story.reload
        expect(story.title).to eq("Updated Title")
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested story" do
        story_to_delete = create(:story, board: board)
        expect {
          delete project_story_url(project, story_to_delete)
        }.to change(Story, :count).by(-1)
      end
    end

    describe "PATCH /move" do
      it "moves the story" do
        other_board = create(:board, project: project)
        patch move_project_story_url(project, story), params: { story: { board_id: other_board.id, position: 1 } }
        story.reload
        expect(story.board).to eq(other_board)
      end
    end
  end

  describe "as project guest" do
    before { sign_in project_guest }

    describe "GET /show" do
      it "succeeds" do
        get project_story_url(project, story)
        expect(response).to be_successful
      end
    end

    describe "GET /new" do
      it "is forbidden" do
        expect { get new_project_story_url(project, board_id: board.id) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe "POST /create" do
      it "is forbidden" do
        expect {
          post project_stories_url(project), params: { story: valid_attributes }
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe "PATCH /update" do
      it "is forbidden" do
        expect {
          patch project_story_url(project, story), params: { story: { title: "New Name" } }
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe "DELETE /destroy" do
      it "is forbidden" do
        expect {
          delete project_story_url(project, story)
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe "PATCH /move" do
      it "is forbidden" do
        other_board = create(:board, project: project)
        expect {
          patch move_project_story_url(project, story), params: { story: { board_id: other_board.id, position: 1 } }
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe "as an unrelated user" do
    before { sign_in other_user }

    it "is forbidden to access show" do
      get project_story_url(project, story)
      expect(response).to have_http_status(404)
    end

    it "is forbidden to access new" do
      get new_project_story_url(project, board_id: board.id)
      expect(response).to have_http_status(404)
    end
  end

  describe "when not authenticated" do
    it "redirects from show to the login page" do
      get project_story_url(project, story)
      expect(response).to redirect_to(new_user_session_url)
    end

    it "redirects from new to the login page" do
      get new_project_story_url(project, board_id: board.id)
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end