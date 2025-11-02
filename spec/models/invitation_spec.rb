require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:organization) { create(:organization) }
  let(:sender) { create(:user) }
  let(:recipient_email) { 'new_user@example.com' }

  before do
    organization.users << sender
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      invitation = build(:invitation, organization: organization, sender: sender, email: recipient_email)
      expect(invitation).to be_valid
    end

    it 'is invalid without an email' do
      invitation = build(:invitation, email: nil)
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a poorly formatted email' do
      invitation = build(:invitation, email: 'invalid-email')
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to include('is invalid')
    end

    it 'is invalid if an invitation for that email already exists for the organization' do
      create(:invitation, organization: organization, sender: sender, email: recipient_email)
      invitation = build(:invitation, organization: organization, sender: sender, email: recipient_email)
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to include('has already been taken')
    end

    context 'when recipient is already a member' do
      it 'is invalid' do
        existing_user = create(:user, email: recipient_email)
        organization.users << existing_user

        invitation = build(:invitation, organization: organization, sender: sender, email: recipient_email)
        expect(invitation).not_to be_valid
        expect(invitation.errors[:email]).to include('is already a member of this organization')
      end
    end

    context 'when sender is not a member of the organization' do
      it 'is invalid' do
        other_organization = create(:organization)
        invitation = build(:invitation, organization: other_organization, sender: sender, email: recipient_email)
        expect(invitation).not_to be_valid
        expect(invitation.errors[:sender]).to include('must be a member of the organization')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:recipient).class_name('User').optional }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, accepted: 1, expired: 2).with_default(:pending) }
    it { should define_enum_for(:role).with_values(owner: 0, member: 1, guest: 2).with_default(:member) }
  end

  describe 'callbacks' do
    it 'generates a token before creation' do
      invitation = create(:invitation, organization: organization, sender: sender, email: recipient_email)
      expect(invitation.token).to be_present
    end
  end
end
