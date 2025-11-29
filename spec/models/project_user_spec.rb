require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  describe 'validations' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:project) { create(:project, organization: organization) }
    let!(:organization_user) {  create(:organization_user, organization: organization, user: user, role: :owner) }
    subject { create(:project_user, user: user, project: project) }

    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should belong_to(:added_by).class_name('User').optional }
  end

  describe 'enum role' do
    it { should define_enum_for(:role).with_values(owner: 0, member: 1, guest: 2) }
  end

  describe 'callbacks' do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:user) { create(:user) }
    let!(:organization_user) {  create(:organization_user, organization: organization, user: user, role: :owner) }
    let(:adder) { create(:user) }
    let!(:organization_user) {  create(:organization_user, organization: organization, user: user, role: :owner) }

    context '@send_added_to_project_email' do
      it 'sends an email when added_by is present' do
        project_user = build(:project_user, project: project, user: user, added_by: adder)
        expect { project_user.save! }.to have_enqueued_job(Noticed::EventJob)
      end

      it 'does not send an email when added_by is nil' do
        project_user = build(:project_user, project: project, user: user, added_by: nil)
        expect { project_user.save! }.not_to have_enqueued_job(Noticed::EventJob)
      end
    end
  end

  describe '#check_if_user_belongs_to_organization' do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:user_in_org) { create(:user) }
    let!(:organization_user) {  create(:organization_user, organization: organization, user: user_in_org, role: :owner) }
    let(:user_not_in_org) { create(:user) }

    context 'when user is nil' do
      it 'does not add an error' do
        project_user = build(:project_user, project: project, user: nil)
        project_user.validate
        expect(project_user.errors[:user]).to include("must exist")
      end
    end

    context 'when user belongs to the organization' do
      it 'does not add an error' do
        project_user = build(:project_user, project: project, user: user_in_org)
        project_user.validate
        expect(project_user.errors[:user]).to be_empty
      end
    end

    context 'when user does not belong to the organization' do
      it 'adds an error to user' do
        project_user = build(:project_user, project: project, user: user_not_in_org)
        project_user.valid?
        expect(project_user.errors[:user]).to include("must belongs to organization")
      end
    end

    context 'when organization on project is nil' do
      it 'should not throw errors' do
        project = build(:project, organization: nil)
        project_user = project.project_users.build(user: user_in_org)
        expect(project_user).to be_valid
        expect(project).not_to be_valid
      end
    end
  end
end
