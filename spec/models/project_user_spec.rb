require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  describe 'validations' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:project) { create(:project, organization: organization) }
    subject { create(:project_user, user: user, project: project) }

    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'enum role' do
    it { should define_enum_for(:role).with_values(owner: 0, member: 1, guest: 2) }
  end
end
