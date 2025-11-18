require "rails_helper"

describe "Users::RegistrationsController", type: :request do
  describe "GET /user/sign_up" do
    it "renders the sign up form" do
      pending "Remove pending when going live !"
      get new_user_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /user" do
    let(:user_params) { { email: "user@example.com", password: "password", password_confirmation: "password" } }

    context "with valid parameters" do
      it "creates a new user" do
        pending "Remove pending when going live !"
        expect {
          post user_registration_path, params: { user: user_params }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        pending "Remove pending when going live !"
        post user_registration_path, params: { user: user_params.merge(email: "") }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when registering a new user with an invitation token in session' do
      let(:organization) { create(:organization) }
      let(:sender) { create(:user) }
      let(:new_user_email) { 'register_user@example.com' }
      let(:invitation) { create(:invitation, organization: organization, sender: sender, email: new_user_email, role: :member) }

      before do
        create(:organization_user, organization: organization, user: sender, role: :owner)
        get accept_invitation_path(token: invitation.token)
      end

      it 'creates a new user, accepts the invitation, and adds them to the organization' do
        pending "Remove pending when going live !"
        valid_registration_params = { user: { email: new_user_email, password: 'password', password_confirmation: 'password', full_name: 'New User' } }

        expect {
          post user_registration_path, params: valid_registration_params
        }.to change(User, :count).by(1)
         .and change { invitation.reload.status }.to('accepted')
         .and change { organization.users.count }.by(1)

        new_user = User.find_by(email: new_user_email)
        expect(new_user.organizations).to include(organization)
        expect(new_user.organization_users.find_by(organization: organization).role).to eq('member')
        expect(session[:invitation_token]).to be_nil
      end
    end
  end

  describe "GET /user/edit" do
    let(:user) { create(:user) }

    it "renders the edit user form" do
      sign_in(user)
      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects to sign in if not signed in" do
      get edit_user_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "PATCH /user" do
    let(:user) { create(:user) }

    context "with valid parameters" do
      it "updates the user" do
        sign_in(user)
        patch user_registration_path, params: { user: { email: "new_email@example.com", current_password: "password" } }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(edit_user_registration_path)
        expect(user.reload.unconfirmed_email).to eq("new_email@example.com")
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        sign_in(user)
        patch user_registration_path, params: { user: { email: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not signed in" do
      it "returns 404 HTTP status" do
        patch edit_user_registration_path
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /user" do
    let(:user) { create(:user) }

    context "when user is signed in" do
      it "deletes the user" do
        sign_in(user)
        expect {
          delete user_registration_path
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in" do
        delete user_registration_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
