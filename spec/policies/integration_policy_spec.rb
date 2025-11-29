require 'rails_helper'

RSpec.describe IntegrationPolicy, type: :policy do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner_org) { create(:user) }
  let(:owner_project) { create(:user) }
  let(:member) { create(:user) }
  let(:integration) { build(:integration, project: project) }

  before do
    create(:organization_user, organization: organization, user: owner_org, role: :owner)
    create(:organization_user, organization: organization, user: owner_project, role: :member)
    create(:project_user, project: project, user: owner_project, role: :owner)

    create(:organization_user, organization: organization, user: member, role: :member)
    create(:project_user, project: project, user: member, role: :member)
  end

  subject { described_class }

  permissions :index?, :create?, :new?, :update?, :edit?, :destroy? do
    it "grants access to organization owner" do
      expect(subject).to permit(owner_org, integration)
    end

    it "grants access to project owner" do
      expect(subject).to permit(owner_project, integration)
    end

    it "denies access to regular member" do
      expect(subject).not_to permit(member, integration)
    end
  end

  permissions :index? do
    it "denies access if project is missing on record" do
      # This case handles potential nil project edge cases, though controller ensures it.
      integration.project = nil
      expect(subject).not_to permit(owner_org, integration)
    end
  end
end
