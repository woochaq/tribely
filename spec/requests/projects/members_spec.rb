require 'rails_helper'

RSpec.describe "Projects::Members", type: :request do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner_org) { create(:user) }
  let(:owner_project) { create(:user) }
  let(:member_project) { create(:user) }
  let(:non_member_org) { create(:user) }
  let(:user_to_add) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: owner_project, role: :member)
    create(:organization_user, organization: organization, user: member_project, role: :member)
    create(:organization_user, organization: organization, user: user_to_add, role: :member)
  end
  let!(:owner_org_user) { create(:organization_user, organization: organization, user: owner_org, role: :owner) }
  let!(:owner_project_user) { create(:project_user, project: project, user: owner_project, role: :owner) }
  let!(:member_project_user) { create(:project_user, project: project, user: member_project, role: :member) }


  describe "POST /projects/:project_id/members" do
    let(:valid_attributes) { { project_user: { user_id: user_to_add.id, role: :member } } }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "adds a new member to the project" do
        expect {
          post project_members_path(project), params: valid_attributes
        }.to change(project.project_users, :count).by(1)
        .and have_enqueued_job(Noticed::EventJob)

        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:notice]).to eq("#{user_to_add.name} has been added to the project.")
        expect(ProjectUser.last.added_by).to eq(owner_org)
      end

      it "does not add an existing member" do
        project.users << user_to_add
        expect {
          post project_members_path(project), params: valid_attributes
        }.not_to change(project.project_users, :count)

        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to be_present
      end

      it "does not add a user who is not in the organization" do
        user_to_add.organizations = []
        post project_members_path(project), params: valid_attributes
        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to eq("User must belongs to organization")
      end
    end

    context "when logged in as a project owner" do
      before { sign_in owner_project }

      it "adds a new member to the project" do
        expect {
          post project_members_path(project), params: valid_attributes
        }.to change(project.project_users, :count).by(1)

        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:notice]).to eq("#{user_to_add.name} has been added to the project.")
      end
    end

    context "when logged in as a project member" do
      before { sign_in member_project }

      it "does not add a member and redirect to projects_path" do
        post project_members_path(project), params: valid_attributes
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        post project_members_path(project), params: valid_attributes
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /projects/:project_id/members/:id/edit" do
    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "renders the edit form for a member" do
        get edit_project_member_path(project, member_project_user)
        expect(response).to have_http_status(:ok)
      end

      it "does not render the edit form for themselves" do
        get edit_project_member_path(project, owner_org_user) # owner_org_user is not a project_user
        expect(response).to have_http_status(:not_found) # Because owner_org_user is not a project_user
      end
    end

    context "when logged in as a project owner" do
      before { sign_in owner_project }

      it "renders the edit form for a member" do
        get edit_project_member_path(project, member_project_user)
        expect(response).to have_http_status(:ok)
      end

      it "does not render the edit form for themselves" do
        get edit_project_member_path(project, owner_project_user)
        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to eq("You cannot edit your own role.")
      end
    end

    context "when logged in as a project member" do
      before { sign_in member_project }

      it "does not render the edit form and redirect to projects_path" do
        get edit_project_member_path(project, owner_project_user)
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get edit_project_member_path(project, member_project_user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /projects/:project_id/members/:id" do
    let(:new_role) { :guest }

    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "updates the member's role" do
        patch project_member_path(project, member_project_user), params: { project_user: { role: new_role } }
        expect(response).to have_http_status(:ok) # Turbo Stream response
        expect(member_project_user.reload.role).to eq(new_role.to_s)
      end

      it "returns unprocessable_content with invalid parameters" do
        patch project_member_path(project, member_project_user), params: { project_user: { role: nil } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(member_project_user.reload.role).not_to be_nil
      end
    end

    context "when logged in as a project owner" do
      before { sign_in owner_project }

      it "updates the member role" do
        patch project_member_path(project, member_project_user), params: { project_user: { role: new_role } }
        expect(response).to have_http_status(:ok)
        expect(member_project_user.reload.role).to eq(new_role.to_s)
      end

      it "does not allow an owner to update their own role" do
        patch project_member_path(project, owner_project_user), params: { project_user: { role: new_role } }
        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to eq("You cannot update your own role.")
      end
    end

    context "when logged in as a project member" do
      before { sign_in member_project }

      it "does not update the member role and redirect to root path" do
        patch project_member_path(project, owner_project_user), params: { project_user: { role: new_role } }
        expect(response).to redirect_to(projects_path)
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        patch project_member_path(project, member_project_user), params: { project_user: { role: new_role } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /projects/:project_id/members/:id" do
    context "when logged in as an organization owner" do
      before { sign_in owner_org }

      it "removes a member from the project" do
        expect {
          delete project_member_path(project, member_project_user)
        }.to change(project.project_users, :count).by(-1)

        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:notice]).to eq("#{member_project_user.user.name} has been removed from the project.")
      end

      it "does not allow an owner to remove themselves" do
        sign_in owner_project_user.user
        delete project_member_path(project, owner_project_user)
        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to eq("You cannot remove yourself from the project.")
      end
    end

    context "when logged in as a project owner" do
      before { sign_in owner_project }

      it "removes a member from the project" do
        expect {
          delete project_member_path(project, member_project_user)
        }.to change(project.project_users, :count).by(-1)

        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:notice]).to eq("#{member_project_user.user.name} has been removed from the project.")
      end

      it "does not allow an owner to remove themselves" do
        delete project_member_path(project, owner_project_user)
        expect(response).to redirect_to(settings_project_path(project))
        expect(flash[:alert]).to eq("You cannot remove yourself from the project.")
      end
    end

    context "when logged in as a project member" do
      before { sign_in member_project }

      it "does not remove a member and redirect to projects_path" do
        delete project_member_path(project, owner_project_user)
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        delete project_member_path(project, member_project_user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
