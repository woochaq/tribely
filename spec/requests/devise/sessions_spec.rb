require "rails_helper"

describe "Devise::SessionsController", type: :request do
  describe "POST /users/sign_in" do
    let(:user) { create(:user, password: "password") }
    let(:valid_credentials) { { email: user.email, password: "password" } }
    let(:invalid_credentials) { { email: user.email, password: "wrongpassword" } }

    context "with valid credentials" do
      it "signs the user in" do
        post user_session_path, params: { user: valid_credentials }
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(projects_path)
        expect(session["warden.user.user.key"]).to eq([ [ user.id ], user.authenticatable_salt ])
      end

      it "returns a message that user is already signed in" do
        sign_in(user)
        post user_session_path, params: { user: valid_credentials }
        expect(response).to redirect_to(projects_path)
      end
    end

    context "with invalid credentials" do
      it "does not sign the user in" do
        post user_session_path, params: { user: invalid_credentials }
        expect(response).to have_http_status(:unprocessable_content)
        expect(session["warden.user.user.key"]).to be_nil
      end
    end

    context 'when logging in with an invitation token in session' do
      let(:organization) { create(:organization) }
      let(:sender) { create(:user) }
      let(:existing_user_for_invite) { create(:user, password: 'password') }
      let(:invitation) { create(:invitation, organization: organization, sender: sender, email: existing_user_for_invite.email, role: :member) }

      before do
        create(:organization_user, organization: organization, user: sender, role: :owner)
        # Simulate visiting the accept link, which lazy-loads the invitation
        get accept_invitation_path(token: invitation.token)
      end

      it 'logs in the user, accepts the invitation, and redirects to the organization page' do
        valid_login_params = { user: { email: existing_user_for_invite.email, password: 'password' } }

        expect {
          post user_session_path, params: valid_login_params
        }.to change { invitation.reload.status }.to('accepted')
        .and change { organization.users.count }.by(1)

        expect(response).to redirect_to(organization_path(organization))
        expect(session[:invitation_token]).to be_nil
      end
    end

    context 'when logging in without an invitation token' do
      let(:another_user) { create(:user, password: 'password') }
      let(:valid_login_params) do
        { user: { email: another_user.email, password: 'password' } }
      end

      it 'logs in the user and redirects to the default path' do
        expect {
          post user_session_path, params: valid_login_params
        }.not_to change { Invitation.count }

        expect(response).to redirect_to(projects_path) # Devise default after sign in
        expect(session[:invitation_token]).to be_nil
      end
    end
  end
end
