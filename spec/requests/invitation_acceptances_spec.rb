require 'rails_helper'

RSpec.describe "InvitationAcceptances", type: :request do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user) }
  let(:new_user_email) { 'new_user@example.com' }
  let(:existing_user) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: sender, role: :owner)
  end

  let!(:pending_invitation) { create(:invitation, organization: organization, sender: sender, email: new_user_email, role: :member) }
  let!(:accepted_invitation) { create(:invitation, organization: organization, sender: sender, email: 'accepted@example.com', status: :accepted) }
  let!(:expired_invitation) { create(:invitation, organization: organization, sender: sender, email: 'expired@example.com', status: :expired) }

  describe 'GET /invitations/:token/accept' do
    context 'when invitation is pending' do
      context 'for a new user' do
        it 'redirects to new user registration with email pre-filled and token in session' do
          get accept_invitation_path(token: pending_invitation.token)
          expect(response).to redirect_to(new_user_registration_path(user: { email: new_user_email }))
          expect(session[:invitation_token]).to eq(pending_invitation.token)
        end
      end

      context 'for an existing user who is not logged in' do
        before { pending_invitation.update(email: existing_user.email) }

        it 'redirects to login page with email pre-filled and token in session' do
          get accept_invitation_path(token: pending_invitation.token)
          expect(response).to redirect_to(new_user_session_path(email: existing_user.email))
          expect(session[:invitation_token]).to eq(pending_invitation.token)
        end
      end

      context 'for an existing user who is logged in and email matches' do
        before do
          sign_in existing_user
          pending_invitation.update(email: existing_user.email)
        end

        it 'accepts the invitation and redirects to organization page' do
          expect {
            get accept_invitation_path(token: pending_invitation.token)
          }.to change { pending_invitation.reload.status }.to('accepted')
          .and change { organization.users.count }.by(1)

          expect(response).to redirect_to(organization_path(organization))
          expect(flash[:notice]).to be_present
        end
      end

      context 'for an existing user who is logged in but email does not match' do
        before { sign_in existing_user }

        it 'redirects to root with an alert' do
          get accept_invitation_path(token: pending_invitation.token)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end
    end

    context 'when invitation is already accepted' do
      it 'redirects to root with an alert' do
        get accept_invitation_path(token: accepted_invitation.token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when invitation is expired' do
      it 'redirects to root with an alert' do
        get accept_invitation_path(token: expired_invitation.token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when token is invalid' do
      it 'redirects to root with an alert' do
        get accept_invitation_path(token: 'invalid_token')
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
