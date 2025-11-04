require 'rails_helper'

RSpec.describe ProjectUserPolicy, type: :policy do
  subject { described_class }

  let(:organization) { create(:organization) }
  let(:organization_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:organization_member) { create(:user) }
  let(:other_user) { create(:user) }
  let(:project) { create(:project, organization: organization) }
  let(:project_user) { build(:project_user, project: project, user: organization_member) }

  before do
    create(:organization_user, user: organization_owner, organization: organization, role: :owner)
    create(:organization_user, user: project_owner, organization: organization, role: :member)
    create(:organization_user, user: organization_member, organization: organization, role: :member)
    create(:project_user, user: project_owner, project: project, role: :owner)
  end

  permissions :create?, :edit?, :update?, :destroy? do
    context "when user is organization owner" do
      it "grants access if the user to be added is in the organization" do
        expect(subject).to permit(organization_owner, project_user)
      end

      it "denies access if the user to be added is not in the organization" do
        project_user.user = other_user
        expect(subject).not_to permit(organization_owner, project_user)
      end
    end

    context "when user is project owner" do
      it "grants access if the user to be added is in the organization" do
        expect(subject).to permit(project_owner, project_user)
      end

      it "denies access if the user to be added is not in the organization" do
        project_user.user = other_user
        expect(subject).not_to permit(project_owner, project_user)
      end
    end

    context "when user is an organization member but not project owner" do
      it "denies access" do
        expect(subject).not_to permit(organization_member, project_user)
      end
    end

    context "when user is not in the organization" do
      it "denies access" do
        expect(subject).not_to permit(other_user, project_user)
      end
    end
  end

  describe "permitted_attributes" do
    it "returns the correct attributes" do
      policy = described_class.new(organization_owner, project_user)
      expect(policy.permitted_attributes).to contain_exactly(:user_id)
    end
  end
end
