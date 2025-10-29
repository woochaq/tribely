require 'rails_helper'

RSpec.describe "/projects", type: :request do
  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:owner_org_membership) { create(:organization_user, organization: organization, user: owner, role: :owner) }
  let!(:member_org_membership) { create(:organization_user, organization: organization, user: member, role: :member) }

  let!(:project) do
    create(:project, organization: organization).tap do |p|
      p.project_users.create!(user: owner, role: :owner)
      p.project_users.create!(user: member, role: :member)
    end
  end

  let(:valid_attributes) { { name: "New Project", prefix: "NEW", organization_id: organization.id } }
  let(:invalid_attributes) { { name: "", organization_id: organization.id } }


  describe "GET /index" do
    context "when authenticated as a project member" do
      before { sign_in member }
      it "succeeds" do
        get projects_url
        expect(response).to be_successful
      end
    end

    context "when authenticated as a project owner" do
      before { sign_in owner }
      it "succeeds" do
        get projects_url
        expect(response).to be_successful
      end
    end

    context "when not authenticated" do
      it "redirects to the login page" do
        get projects_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET /show" do
    context "when authenticated as a project member" do
      before { sign_in member }
      it "succeeds" do
        get project_url(project)
        expect(response).to be_successful
      end
    end

    context "when authenticated as a project owner" do
      before { sign_in owner }
      it "succeeds" do
        get project_url(project)
        expect(response).to be_successful
      end
    end

    context "when authenticated as an unrelated user" do
      before { sign_in other_user }
      it "is forbidden and not found" do
        get project_url(project)
        expect(response).to have_http_status(404)
      end
    end

    context "when not authenticated" do
      it "redirects to the login page" do
        get project_url(project)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET /new" do
    context "when authenticated" do
      before { sign_in member }
      it "succeeds" do
        get new_project_url
        expect(response).to be_successful
      end
    end

    context "when not authenticated" do
      it "redirects to the login page" do
        get new_project_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST /create" do
    context "when authenticated" do
      before { sign_in member }

      context "with valid parameters" do
        it "creates a new Project and makes the creator an owner" do
          expect { post projects_url, params: { project: valid_attributes } }.to change(Project, :count).by(1)
          new_project = Project.last
          expect(new_project.organization).to eq(organization)
          expect(new_project.project_users.find_by(user: member).role).to eq("owner")
        end

        it "redirects to the created project" do
          post projects_url, params: { project: valid_attributes }
          expect(response).to redirect_to(project_url(Project.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Project" do
          expect { post projects_url, params: { project: invalid_attributes } }.not_to change(Project, :count)
        end

        it "renders a 422 Unprocessable Content response" do
          post projects_url, params: { project: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when not authenticated" do
      it "redirects to the login page" do
        post projects_url, params: { project: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET /edit" do
    context "when authenticated as a project owner" do
      before { sign_in owner }
      it "succeeds" do
        get edit_project_url(project)
        expect(response).to be_successful
      end
    end

    context "when authenticated as a project member" do
      before { sign_in member }
      it "is forbidden and raises NotAuthorizedError" do
        expect { get edit_project_url(project) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe "PATCH /update" do
    context "when authenticated as a project owner" do
      before { sign_in owner }
      it "updates the project and redirects" do
        patch project_url(project), params: { project: { name: "Updated Name" } }
        project.reload
        expect(project.name).to eq("Updated Name")
        expect(response).to redirect_to(projects_url)
      end
    end

    context "when authenticated as a project member" do
      before { sign_in member }
      it "is forbidden and raises NotAuthorizedError" do
        expect { patch project_url(project), params: { project: { name: "New Name" } } }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when authenticated as a project owner" do
      before { sign_in owner }
      it "destroys the project and redirects" do
        expect { delete project_url(project) }.to change(Project, :count).by(-1)
        expect(response).to redirect_to(projects_url)
      end
    end

    context "when authenticated as a project member" do
      before { sign_in member }
      it "is forbidden and raises NotAuthorizedError" do
        expect { delete project_url(project) }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
