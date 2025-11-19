require 'rails_helper'

RSpec.describe Webhook, type: :model do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:owner) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:project_user, project: project, user: owner, role: :owner)
  end

  subject { build(:webhook, project: project, board: board, created_by: owner) }

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:board) }
    it { should belong_to(:created_by).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:board) }

    context 'custom validations' do
      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end

      it 'is invalid if board does not belong to project' do
        other_project = create(:project)
        other_board = create(:board, project: other_project)
        subject.board = other_board
        expect(subject).not_to be_valid
        expect(subject.errors[:board]).to include("must belong to the project")
      end

      it 'is invalid if creator is not project owner' do
        member = create(:user)
        create(:organization_user, organization: organization, user: member, role: :member)
        create(:project_user, project: project, user: member, role: :member)

        subject.created_by = member
        expect(subject).not_to be_valid
        expect(subject.errors[:created_by]).to include("must be a project owner")
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:webhook_type).with_values(create_story: 0) }
  end

  describe 'scopes' do
    let!(:active_webhook) { create(:webhook, active: true) }
    let!(:inactive_webhook) { create(:webhook, active: false) }

    it 'returns only active webhooks' do
      expect(Webhook.active).to include(active_webhook)
      expect(Webhook.active).not_to include(inactive_webhook)
    end
  end

  describe 'token generation' do
    it 'generates a token on creation' do
      webhook = create(:webhook)
      expect(webhook.token).to be_present
    end
  end
end
