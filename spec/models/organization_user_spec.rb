require "rails_helper"

RSpec.describe OrganizationUser, type: :model do
  describe "validations" do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    subject { create(:organization_user, user: user, organization: organization) }

    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:organization_id).scoped_to(:user_id) }
  end

  describe "enum role" do
    it { should define_enum_for(:role).with_values(owner: 0, member: 1, guest: 2) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end
end
