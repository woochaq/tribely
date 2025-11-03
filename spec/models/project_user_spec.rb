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
    it { should belong_to(:added_by).class_name('User').optional }
  end

  describe 'enum role' do
    it { should define_enum_for(:role).with_values(owner: 0, member: 1, guest: 2) }
  end

  describe 'callbacks' do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:user) { create(:user) }
    let(:adder) { create(:user) }

    context '@send_added_to_project_email' do
      it 'sends an email when added_by is present' do
        project_user = build(:project_user, project: project, user: user, added_by: adder)
        expect { project_user.save! }.to have_enqueued_mail(ProjectMemberMailer, :added_to_project_email)
      end

      it 'does not send an email when added_by is nil' do
        project_user = build(:project_user, project: project, user: user, added_by: nil)
        expect { project_user.save! }.not_to have_enqueued_mail(ProjectMemberMailer, :added_to_project_email)
      end
    end
  end
end
