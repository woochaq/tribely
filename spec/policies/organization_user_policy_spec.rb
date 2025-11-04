require 'rails_helper'

RSpec.describe OrganizationUserPolicy, type: :policy do
  subject { described_class }

  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:owner_org_user) { create(:organization_user, organization: organization, user: owner, role: :owner) }
  let!(:member_org_user) { create(:organization_user, organization: organization, user: member, role: :member) }

  permissions :edit?, :update?, :destroy? do
    it "grants access if user is an organization owner and is not the record" do
      expect(subject).to permit(owner, member_org_user)
    end

    it "denies access if user is an organization owner and is the record" do
      expect(subject).not_to permit(owner, owner_org_user)
    end

    it "denies access if user is a member" do
      expect(subject).not_to permit(member, owner_org_user)
    end

    it "denies access if user is not in the organization" do
      expect(subject).not_to permit(other_user, member_org_user)
    end
  end
end
