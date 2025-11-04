require 'rails_helper'

RSpec.describe "Organizations::Invitations", type: :request do
  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:non_member) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:organization_user, organization: organization, user: member, role: :member)
  end

  describe 'POST /organizations/:organization_id/invitations' do
    let(:valid_attributes) { { invitation: { email: 'new_user@example.com', role: 'member' } } }

    context 'when logged in as an owner' do
      before { sign_in owner }

      it 'creates a new invitation and sends an email' do
        expect {
          post organization_invitations_path(organization), params: valid_attributes
        }.to change(Invitation, :count).by(1)
        .and have_enqueued_mail(InvitationMailer, :invitation_email)

        expect(response).to redirect_to(organization_members_path(organization))
        expect(flash[:notice]).to eq('Invitation sent successfully.')
      end

      it 'does not create an invitation with invalid attributes' do
        expect {
          post organization_invitations_path(organization), params: { invitation: { email: '' } }
        }.not_to change(Invitation, :count)

        expect(response).to redirect_to(organization_members_path(organization))
        expect(flash[:alert]).to be_present
      end
    end

    context 'when logged in as a member' do
      before { sign_in member }

      it 'does not create an invitation and redirects to projects path' do
        post organization_invitations_path(organization), params: valid_attributes
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        post organization_invitations_path(organization), params: valid_attributes
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /organizations/:organization_id/invitations/:id' do
    let!(:invitation) { create(:invitation, organization: organization, sender: owner) }

    context 'when logged in as an owner' do
      before { sign_in owner }

      it 'deletes the invitation' do
        expect {
          delete organization_invitation_path(organization, invitation)
        }.to change(Invitation, :count).by(-1)
        expect(response).to redirect_to(organization_members_path(organization))
        expect(flash[:notice]).to eq('Invitation cancelled successfully.')
      end
    end

    context 'when logged in as a member' do
      before { sign_in member }

      it 'does not delete the invitation and raises and redirects to projects_path' do
        delete organization_invitation_path(organization, invitation)
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe 'POST /organizations/:organization_id/invitations/:id/resend' do
    let!(:invitation) { create(:invitation, organization: organization, sender: owner) }

    context 'when logged in as an owner' do
      before { sign_in owner }

      it 'resends the invitation email' do
        expect {
          post resend_organization_invitation_path(organization, invitation)
        }.to have_enqueued_mail(InvitationMailer, :invitation_email)

        expect(response).to redirect_to(organization_members_path(organization))
        expect(flash[:notice]).to eq('Invitation re-sent successfully.')
      end
    end

    context 'when logged in as a member' do
      before { sign_in member }

      it 'does not resend the invitation and raises redirects to projects_path' do
        post resend_organization_invitation_path(organization, invitation)
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
