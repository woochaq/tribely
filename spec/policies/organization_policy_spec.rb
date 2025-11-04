require 'rails_helper'

RSpec.describe OrganizationPolicy, type: :policy do
  subject { described_class }

  let!(:owner) { create(:user) }
  let!(:member) { create(:user) }
  let!(:other_user) { create(:user) }

  let(:shared_organization) { create(:organization) }

  before do
    create(:organization_user, user: owner, organization: shared_organization, role: :owner)
    create(:organization_user, user: member, organization: shared_organization, role: :member)
  end

  permissions :index? do
    it "grants access to any authenticated user" do
      expect(subject).to permit(owner, Organization)
    end
  end

  permissions :show? do
    it "grants access to the shared_organization owner" do
      expect(subject).to permit(owner, shared_organization)
    end

    it "grants access to a member" do
      expect(subject).to permit(member, shared_organization)
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, shared_organization)
    end
  end

  permissions :edit?, :update? do
    it "grants access to the organization owner" do
      expect(subject).to permit(owner, shared_organization)
    end

    it "denies access to a member" do
      expect(subject).not_to permit(member, shared_organization)
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, shared_organization)
    end
  end

  describe "Scope" do
    it "resolves the correct organizations for each user" do
      # Owner should see their own default organization AND the shared one
      owner_scope = described_class::Scope.new(owner, Organization.all).resolve
      expect(owner_scope).to contain_exactly(owner.organizations.first, shared_organization)

      # Member should see their own default organization AND the shared one
      member_scope = described_class::Scope.new(member, Organization.all).resolve
      expect(member_scope).to contain_exactly(member.organizations.first, shared_organization)

      # Other user should ONLY see their own default organization
      other_user_scope = described_class::Scope.new(other_user, Organization.all).resolve
      expect(other_user_scope).to contain_exactly(other_user.organizations.first)
    end
  end

  describe "permitted_attributes" do
    it "returns the correct attributes for an owner" do
      policy = described_class.new(owner, shared_organization)
      expect(policy.permitted_attributes).to contain_exactly(:name, :avatar)
    end

    it "returns an empty array for a member" do
      policy = described_class.new(member, shared_organization)
      expect(policy.permitted_attributes).to be_empty
    end
  end
end
