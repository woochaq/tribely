require 'rails_helper'

RSpec.describe StoryPolicy, type: :policy do
  subject { described_class }

  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:story) { create(:story, board: board) }

  let(:org_owner) { create(:user) }
  let(:project_owner) { create(:user) }
  let(:project_member) { create(:user) }
  let(:project_guest) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: org_owner, role: :owner)
    create(:organization_user, organization: organization, user: project_owner, role: :member)
    create(:organization_user, organization: organization, user: project_member, role: :member)
    create(:organization_user, organization: organization, user: project_guest, role: :member)
    create(:project_user, project: project, user: project_owner, role: :owner)
    create(:project_user, project: project, user: project_member, role: :member)
    create(:project_user, project: project, user: project_guest, role: :guest)
  end

  permissions :show? do
    it "grants access to everyone" do
      expect(subject).to permit(org_owner, story)
      expect(subject).to permit(project_owner, story)
      expect(subject).to permit(project_member, story)
      expect(subject).to permit(project_guest, story)
      expect(subject).to permit(other_user, story)
    end
  end

  permissions :new?, :create?, :edit?, :update?, :destroy?, :move? do
    it "grants access to the organization owner" do
      expect(subject).to permit(org_owner, story)
    end

    it "grants access to the project owner" do
      expect(subject).to permit(project_owner, story)
    end

    it "grants access to the project member" do
      expect(subject).to permit(project_member, story)
    end

    it "denies access to the project guest" do
      expect(subject).not_to permit(project_guest, story)
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, story)
    end
  end
end
