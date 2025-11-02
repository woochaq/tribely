require 'rails_helper'

RSpec.describe InvitationPolicy, type: :policy do
  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:non_member) { create(:user) }
  let(:invitation) { create(:invitation, organization: organization, sender: owner) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:organization_user, organization: organization, user: member, role: :member)
  end

  permissions :create?, :destroy?, :resend? do
    it "grants access if user is an owner of the organization" do
      expect(described_class).to permit(owner, invitation)
    end

    it "denies access if user is a member of the organization" do
      expect(described_class).not_to permit(member, invitation)
    end

    it "denies access if user is not a member of the organization" do
      expect(described_class).not_to permit(non_member, invitation)
    end
  end

  describe 'permitted_attributes' do
    it 'permits the :email and :role attributes' do
      policy = described_class.new(owner, invitation)
      expect(policy.permitted_attributes).to contain_exactly(:email, :role)
    end
  end
end
