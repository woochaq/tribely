require 'rails_helper'

RSpec.describe "/projects/:project_id/stories", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }

  let(:org_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:organization_user, organization: organization, user: project_owner, role: :member)
    create(:organization_user, organization: organization, user: project_member, role: :member)
    create(:organization_user, organization: organization, user: project_guest, role: :guest)
    create(:project_user, project: project, user: org_owner, role: :member)
    create(:project_user, project: project, user: project_owner, role: :owner)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  let!(:story) { create(:story, board: board, owner: project_owner) }

  let(:valid_attributes) { { board_id: board.id, title: "New Story", description: nil } }
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
        expect(Story.last.last_updated_by).to eq(org_owner)
      end

      it "prevent adding story to the board from different project" do
        project2 = create(:project, organization: organization)
        create(:project_user, project: project2, user: project_owner, role: :owner)
        expect do
          post project_stories_url(project), params: { story: valid_attributes.merge(board_id: project2.boards.first.id) }
        end.to_not change(Story, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "PATCH /update" do
      it "updates the requested story" do
        expect(story.last_updated_by).to be_nil
        patch project_story_url(project, story), params: { story: { title: "Updated Title" } }
        story.reload
        expect(story.title).to eq("Updated Title")
        expect(story.last_updated_by).to eq(org_owner)
      end

      it "prevent updating story to the board from different project" do
        project2 = create(:project, organization: organization)
        expect(story.last_updated_by).to be_nil
        patch project_story_url(project, story), params: { story: { board_id: project2.boards.first.id } }
        story.reload
        expect(story.last_updated_by).to be_nil
        expect(story.board).to eq(board)
        expect(response).to have_http_status(:unprocessable_content)
      end

      context "with state_change parameter" do
        it "updates the status and re-renders the form" do
          patch project_story_url(project, story), params: { story: { status: :in_progress }, state_change: true }
          story.reload
          expect(story.status).to eq("in_progress")
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("form") # Check if the form is re-rendered
        end
      end
    end

    describe "PATCH /autosave" do
      it "updates the requested story" do
        expect(story.last_updated_by).to be_nil
        patch autosave_project_story_url(project, story), params: { story: { title: "Updated Title" } }
        story.reload
        expect(story.title).to eq("Updated Title")
        expect(story.last_updated_by).to eq(org_owner)
      end

      it "prevent updating story to the board from different project" do
        project2 = create(:project, organization: organization)
        expect(story.last_updated_by).to be_nil
        patch autosave_project_story_url(project, story), params: { story: { board_id: project2.boards.first.id } }
        story.reload
        expect(story.last_updated_by).to be_nil
        expect(story.board).to eq(board)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "DELETE /destroy" do
      it "destroys the requested story" do
        expect {
          delete project_story_url(project, story)
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

      it "prevent moving story to differenet project" do
        project2 = create(:project, organization: organization)
        create(:project_user, project: project2, user: project_owner, role: :owner)
        patch move_project_story_url(project, story), params: { story: { board_id: project2.boards.first.id, position: 1 } }
        expect(response).to have_http_status(:unprocessable_content)
        story.reload
        expect(story.project).to eq(project)
        expect(story.board).to eq(board)
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
        expect {
          delete project_story_url(project, story)
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
        expect {
          delete project_story_url(project, story)
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
        get new_project_story_url(project, board_id: board.id)
        expect(response).to redirect_to(projects_path)
      end
    end

    describe "POST /create" do
      it "is forbidden" do
        post project_stories_url(project), params: { story: valid_attributes }
        expect(response).to redirect_to(projects_path)
      end
    end

    describe "PATCH /update" do
      it "is forbidden" do
        patch project_story_url(project, story), params: { story: { title: "New Name" } }
        expect(response).to redirect_to(projects_path)
      end
    end

    describe "DELETE /destroy" do
      it "is forbidden" do
        delete project_story_url(project, story)
        expect(response).to redirect_to(projects_path)
      end
    end

    describe "PATCH /move" do
      it "is forbidden" do
        other_board = create(:board, project: project)
        patch move_project_story_url(project, story), params: { story: { board_id: other_board.id, position: 1 } }
        expect(response).to redirect_to(projects_path)
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

  describe "GET /search" do
    let!(:story1) { create(:story, board: board, title: "Searchable Story", owner: project_owner) }
    let!(:story2) { create(:story, board: board, title: "Another One", owner: project_owner) }
    let!(:story3) { create(:story, board: board, title: "Archived Searchable", status: :archived, owner: project_owner) }

    before do
      sign_in project_owner
    end

    context "with a valid query" do
      before do
        get search_project_stories_path(project), params: { query: "Searchable" }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the matching story" do
        expect(response.body).to include("Searchable Story")
      end

      it "does not return non-matching stories" do
        expect(response.body).not_to include("Another One")
      end

      it "does not return archived stories" do
        expect(response.body).not_to include("Archived Searchable")
      end
    end

    context "with an empty query" do
      before do
        get search_project_stories_path(project), params: { query: "" }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns no stories" do
        expect(response.body).to include("No stories found.")
      end
    end

    context "when not authenticated" do
      it "redirects to the sign-in page" do
        sign_out project_member
        get search_project_stories_path(project), params: { query: "test" }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /mentions" do
    let(:user) { create(:user) }
    let(:organization) { user.organizations.first }
    let(:project) { create(:project, organization: organization, prefix: "PROJ") }
    let(:board) { project.boards.first }
    let(:other_project) { create(:project, organization: organization, prefix: "OTHER") }

    before do
      project.users << user
      other_project.users << user
      sign_in user
    end

    let!(:story1) { create(:story, board: board, title: "Mentionable Story", owner: user) }
    let!(:story2) { create(:story, board: board, title: "Another One", owner: user) }
    let!(:story3) { create(:story, board: board, title: "Archived Mentionable", status: :archived, owner: user) }
    let!(:other_project_story) { create(:story, board: other_project.boards.first, title: "Other Project Story", owner: user) }

    context "with a valid filter" do
      before do
        get mentions_project_stories_path(project), params: { filter: "Mentionable" }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "returns the matching story" do
        expect(response.body).to include("Mentionable Story")
      end

      it "does not return non-matching stories" do
        expect(response.body).not_to include("Another One")
      end

      it "does not return archived stories" do
        expect(response.body).not_to include("Archived Mentionable")
      end

      it "does not return stories from other projects" do
        get mentions_project_stories_path(project), params: { filter: "Other" }
        expect(response.body).not_to include("Other Project Story")
      end
    end
  end
end
