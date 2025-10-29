require "rails_helper"

RSpec.describe OrganizationUser, type: :model do
  describe "validations" do
    it { should validate_presence_of(:role) }
  end

  describe "enum role" do
    it { should define_enum_for(:role).with_values(owner: 0, member: 1) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end
end
