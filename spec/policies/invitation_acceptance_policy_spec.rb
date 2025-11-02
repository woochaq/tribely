require 'rails_helper'

RSpec.describe InvitationAcceptancePolicy, type: :policy do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user) }
  let(:user) { create(:user) }
  let(:pending_invitation) { create(:invitation, organization: organization, sender: sender, email: 'pending@example.com', status: :pending) }
  let(:accepted_invitation) { create(:invitation, organization: organization, sender: sender, email: 'accepted@example.com', status: :accepted) }
  let(:expired_invitation) { create(:invitation, organization: organization, sender: sender, email: 'expired@example.com', status: :expired) }

  before do
    create(:organization_user, organization: organization, user: sender, role: :owner)
  end

  permissions :new? do
    it 'always grants access' do
      expect(described_class).to permit(user, pending_invitation)
      expect(described_class).to permit(nil, pending_invitation)
      expect(described_class).to permit(user, accepted_invitation)
      expect(described_class).to permit(user, expired_invitation)
    end
  end
end
