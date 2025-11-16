require 'rails_helper'

RSpec.describe DocumentPolicy, type: :policy do
  subject { described_class }

  let(:organization1) { create(:organization) }
  let(:organization2) { create(:organization) }

  let(:project1) { create(:project, organization: organization1) }
  let(:project2) { create(:project, organization: organization1) }
  let(:project3) { create(:project, organization: organization2) }

  let!(:doc_p1) { create(:document, project: project1) }
  let!(:doc_p2) { create(:document, project: project2) }
  let!(:doc_p3) { create(:document, project: project3) }

  let(:owner_org1) { create(:user) }
  let(:member_p1) { create(:user) }
  let(:guest_p1) { create(:user) }
  let(:outsider) { create(:user) }

  before do
    create(:organization_user, organization: organization1, user: owner_org1, role: :owner)
    create(:organization_user, organization: organization1, user: member_p1, role: :member)
    create(:organization_user, organization: organization1, user: guest_p1, role: :guest)
    create(:project_user, project: project1, user: member_p1, role: :member)
    create(:project_user, project: project1, user: guest_p1, role: :guest)
  end

  describe "Scope" do
    it "for owner of organization1, returns documents from project1 and project2" do
      scope = Pundit.policy_scope!(owner_org1, Document)
      expect(scope).to contain_exactly(doc_p1, doc_p2)
    end

    it "for member of project1, returns only document from project1" do
      scope = Pundit.policy_scope!(member_p1, Document)
      expect(scope).to contain_exactly(doc_p1)
    end

    it "for guest of project1, returns no documents" do
      scope = Pundit.policy_scope!(guest_p1, Document)
      expect(scope).to be_empty
    end

    it "for an outsider, returns no documents" do
      scope = Pundit.policy_scope!(outsider, Document)
      expect(scope).to be_empty
    end
  end

  permissions :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it "grants access to owner of organization1" do
      expect(subject).to permit(owner_org1, doc_p1)
    end

    it "grants access to member of project1" do
      expect(subject).to permit(member_p1, doc_p1)
    end

    it "denies access to guest of project1" do
      expect(subject).not_to permit(guest_p1, doc_p1)
    end

    it "denies access to an outsider" do
      expect(subject).not_to permit(outsider, doc_p1)
    end
  end
end
