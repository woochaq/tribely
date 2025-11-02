require 'rails_helper'

RSpec.describe "Organizations::Members", type: :request do
  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }
  let(:member_to_remove) { create(:user) }
  let(:another_member) { create(:user) }
  let(:non_member) { create(:user) }

  let!(:owner_org_user) { create(:organization_user, organization: organization, user: owner, role: :owner) }
  let!(:member_org_user) { create(:organization_user, organization: organization, user: member_to_remove, role: :member) }
  let!(:another_member_org_user) { create(:organization_user, organization: organization, user: another_member, role: :member) }

  describe "DELETE /organizations/:organization_id/members/:id" do
    context "when logged in as an owner" do
      before { sign_in owner }

      it "removes a member from the organization" do
        expect {
          delete organization_member_path(organization, member_org_user)
        }.to change(organization.organization_users, :count).by(-1)

        expect(response).to redirect_to(members_organization_path(organization))
        expect(flash[:notice]).to eq("#{member_to_remove.name} has been removed from the organization.")
      end

      it "does not allow an owner to remove themselves" do
        expect {
          delete organization_member_path(organization, owner_org_user)
        }.not_to change(organization.organization_users, :count)

        expect(response).to redirect_to(members_organization_path(organization))
        expect(flash[:alert]).to eq("You cannot remove yourself from the organization.")
      end
    end

    context "when logged in as a regular member" do
      before { sign_in another_member }

      it "does not remove a member and raises Pundit::NotAuthorizedError" do
        expect {
          delete organization_member_path(organization, member_org_user)
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when logged in as a non-member" do
      before { sign_in non_member }

      it "returns 404 Not Found" do
        delete organization_member_path(organization, member_org_user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        delete organization_member_path(organization, member_org_user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /organizations/:organization_id/members/:id/edit" do
    context "when logged in as an owner" do
      before { sign_in owner }

      it "renders the edit form for a member" do
        get edit_organization_member_path(organization, member_org_user)
        expect(response).to have_http_status(:ok)
      end

      it "does not render the edit form for themselves" do
        get edit_organization_member_path(organization, owner_org_user)
        expect(response).to redirect_to(members_organization_path(organization))
        expect(flash[:alert]).to eq("You cannot edit your own role.")
      end
    end

    context "when logged in as a regular member" do
      before { sign_in another_member }

      it "does not render the edit form and raises Pundit::NotAuthorizedError" do
        expect {
          get edit_organization_member_path(organization, member_org_user)
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get edit_organization_member_path(organization, member_org_user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /organizations/:organization_id/members/:id" do
    let(:new_role) { :guest }

    context "when logged in as an owner" do
      before { sign_in owner }

      it "updates the member's role" do
        patch organization_member_path(organization, member_org_user), params: { organization_user: { role: new_role } }
        expect(response).to have_http_status(:ok) # Turbo Stream response
        expect(member_org_user.reload.role).to eq(new_role.to_s)
      end

      it "does not allow an owner to update their own role" do
        patch organization_member_path(organization, owner_org_user), params: { organization_user: { role: new_role } }
        expect(response).to redirect_to(members_organization_path(organization))
        expect(flash[:alert]).to eq("You cannot update your own role.")
      end

      it "returns unprocessable_content with invalid parameters" do
        patch organization_member_path(organization, member_org_user), params: { organization_user: { role: nil } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(member_org_user.reload.role).not_to be_nil
      end
    end

    context "when logged in as a regular member" do
      before { sign_in another_member }

      it "does not update the member's role and raises Pundit::NotAuthorizedError" do
        expect {
          patch organization_member_path(organization, member_org_user), params: { organization_user: { role: new_role } }
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        patch organization_member_path(organization, member_org_user), params: { organization_user: { role: new_role } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
