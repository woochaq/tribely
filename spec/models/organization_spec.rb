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
end
