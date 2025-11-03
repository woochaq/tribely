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

  describe 'callbacks' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:project1) { create(:project, organization: organization) }
    let(:project2) { create(:project, organization: organization) }
    let!(:organization_user) { create(:organization_user, organization: organization, user: user, role: :member) }
    let!(:organization_user2) { create(:organization_user, organization: organization, user: user2, role: :member) }
    let!(:project_user1) { create(:project_user, project: project1, user: user, role: :member) }
    let!(:project_user2) { create(:project_user, project: project2, user: user, role: :member) }
    let!(:project_user3) { create(:project_user, project: project2, user: user2, role: :member) }

    context "@remove_user_from_organization_projects" do
      it 'removes user from all projects in the organization after being removed from the organization' do
        expect(ProjectUser.count).to eq(3)
        organization_user.destroy
        expect(ProjectUser.count).to eq(1)
      end
    end
  end
end
