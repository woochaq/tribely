require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  subject { described_class }

  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:other_user) { create(:user) }
  let(:project) { create(:project) }

  before do
    create(:project_user, user: owner, project: project, role: :owner)
    create(:project_user, user: member, project: project, role: :member)
  end

  permissions :index?, :new?, :create? do
    it "grants access to any authenticated user" do
      expect(subject).to permit(owner, Project)
      expect(subject).to permit(member, Project)
      expect(subject).to permit(other_user, Project)
    end
  end

  permissions :show? do
    it "grants access to the project owner" do
      expect(subject).to permit(owner, project)
    end

    it "grants access to a project member" do
      expect(subject).to permit(member, project)
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, project)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it "grants access to the project owner" do
      expect(subject).to permit(owner, project)
    end

    it "denies access to a project member" do
      expect(subject).not_to permit(member, project)
    end

    it "denies access to an unrelated user" do
      expect(subject).not_to permit(other_user, project)
    end
  end

  describe "Scope" do
    it "resolves the correct scope for a user" do
      other_project = create(:project)
      create(:project_user, user: other_user, project: other_project, role: :owner)

      owner_scope = described_class::Scope.new(owner, Project.all).resolve
      expect(owner_scope).to contain_exactly(project)

      member_scope = described_class::Scope.new(member, Project.all).resolve
      expect(member_scope).to contain_exactly(project)

      other_user_scope = described_class::Scope.new(other_user, Project.all).resolve
      expect(other_user_scope).to contain_exactly(other_project)
    end
  end

  describe "permitted_attributes" do
    context "for the :create action" do
      it "returns the correct attributes for any user" do
        policy = described_class.new(other_user, Project.new)
        expect(policy.permitted_attributes_for_create).to contain_exactly(:name, :prefix, :organization_id)
      end
    end

    context "for the :update action" do
      it "returns correct attributes for the owner" do
        policy = described_class.new(owner, project)
        expect(policy.permitted_attributes_for_update).to contain_exactly(:name, :prefix)
      end

      it "returns an empty array for a member" do
        policy = described_class.new(member, project)
        expect(policy.permitted_attributes_for_update).to be_empty
      end

      it "returns an empty array for an unrelated user" do
        policy = described_class.new(other_user, project)
        expect(policy.permitted_attributes_for_update).to be_empty
      end
    end
  end
end
