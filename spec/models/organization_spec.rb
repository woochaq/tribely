require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:organization_users) }
    it { should have_many(:users) }
    it { should have_many(:projects).dependent(:destroy) }
  end

  describe "@has_member?" do
    let(:organization) { create(:organization) }
    let(:org_user) { create(:user) }
    let(:org_member_user) { create(:user) }
    let(:org_guest_user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      create(:organization_user, organization: organization, user: org_user, role: :owner)
      create(:organization_user, organization: organization, user: org_member_user, role: :member)
      create(:organization_user, organization: organization, user: org_guest_user, role: :guest)
    end

    it "should check if project has mamber any type of" do
      expect(organization.has_member?(org_user)).to be_truthy
      expect(organization.has_member?(org_member_user)).to be_truthy
      expect(organization.has_member?(org_guest_user)).to be_truthy
      expect(organization.has_member?(other_user)).to be_falsy
    end
  end
end
