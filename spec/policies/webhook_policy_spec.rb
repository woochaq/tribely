require 'rails_helper'

RSpec.describe WebhookPolicy, type: :policy do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }
  let(:webhook) { create(:webhook, project: project, created_by: owner) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:project_user, project: project, user: owner, role: :owner)

    create(:organization_user, organization: organization, user: member, role: :member)
    create(:project_user, project: project, user: member, role: :member)
  end

  subject { described_class }

  permissions :index?, :create?, :update?, :destroy? do
    it "grants access to project owner" do
      expect(subject).to permit(owner, webhook)
    end

    it "denies access to project member" do
      expect(subject).not_to permit(member, webhook)
    end

    it "denies access to unrelated user" do
      expect(subject).not_to permit(other_user, webhook)
    end
  end
end
