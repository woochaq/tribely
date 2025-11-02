require 'rails_helper'

RSpec.describe AcceptInvitation, type: :service do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user) }
  let(:recipient) { create(:user) }

  before do
    organization.users << sender
  end

  let!(:invitation) { create(:invitation, organization: organization, sender: sender, email: recipient.email, role: :member) }

  describe '.call' do
    context 'with valid data' do
      it 'updates the invitation' do
        expect {
          described_class.call(invitation: invitation, user: recipient)
        }.to change { invitation.reload.status }.from('pending').to('accepted')
        .and change { invitation.reload.recipient }.from(nil).to(recipient)
      end

      it 'adds the user to the organization with the correct role' do
        expect {
          described_class.call(invitation: invitation, user: recipient)
        }.to change { organization.users.count }.by(1)

        organization_user = OrganizationUser.find_by(user: recipient, organization: organization)
        expect(organization_user).to be_present
        expect(organization_user.role).to eq('member')
      end

      it 'returns true' do
        result = described_class.call(invitation: invitation, user: recipient)
        expect(result).to be true
      end
    end

    context 'when adding the user to the organization fails' do
      before do
        # Create a validation error by adding the user to the organization beforehand
        organization.users << recipient
      end

      it 'does not update the invitation' do
        expect {
          described_class.call(invitation: invitation, user: recipient)
        }.not_to change { invitation.reload.status }
      end

      it 'returns false' do
        result = described_class.call(invitation: invitation, user: recipient)
        expect(result).to be false
      end
    end
  end
end
