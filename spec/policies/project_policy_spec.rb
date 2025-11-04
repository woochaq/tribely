require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  subject { described_class }

  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:organization) { create(:organization, organization_users: [
    build(:organization_user, user: owner, role: :owner),
    build(:organization_user, user: member, role: :member)
  ]) }
  let(:other_user) { create(:user) }
  let!(:project) do
    create(:project, organization: organization, project_users: [
      build(:project_user, user: owner, role: :owner),
      build(:project_user, user: member, role: :member)
    ])
  end

  permissions :index?, :new? do
    it "grants access to any authenticated user" do
      expect(subject).to permit(owner, Project)
      expect(subject).to permit(member, Project)
      expect(subject).to permit(other_user, Project)
    end
  end

  permissions :create? do
    it "grants access for owner to create project in organization" do
      expect(subject).to permit(owner, build(:project, organization: organization))
    end

    it "grants access any user to create projet without organization" do
      expect(subject).to permit(owner, build(:project, organization: nil))
      expect(subject).to permit(member, build(:project, organization: nil))
      expect(subject).to permit(other_user, build(:project, organization: nil))
    end

    it "denies access for member to create project in organization" do
      expect(subject).not_to permit(member, build(:project, organization: organization))
    end

    it "denies access for other _user to create project in origanization" do
      expect(subject).not_to permit(member, build(:project, organization: organization))
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

    it "grants access to the organization owner" do
      owner.projects = []
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
    let!(:owner_organization) { owner.organization_users.owner.first.organization }
    let!(:project_organization) { create(:project, organization: owner_organization) }
    let!(:project_organization2) { create(:project, organization: owner_organization, project_users: [ build(:project_user, user: owner, role: :member) ]) }

    it "resolves all projects for a user when scoped to all" do
      other_project = create(:project)
      create(:organization_user, organization: other_project.organization, user: other_user, role: :member)
      create(:project_user, user: other_user, project: other_project, role: :owner)

      owner_scope = described_class::Scope.new(owner, Project.all).resolve
      expect(owner_scope).to contain_exactly(project, project_organization, project_organization2)

      member_scope = described_class::Scope.new(member, Project.all).resolve
      expect(member_scope).to contain_exactly(project)

      other_user_scope = described_class::Scope.new(other_user, Project.all).resolve
      expect(other_user_scope).to contain_exactly(other_project)
    end

    it "filters the scope to only projects the user can see within that scope" do
      org = create(:organization)
      user = create(:user)
      project_in_scope = create(:project, organization: org)
      project_outside_scope = create(:project, organization: org)
      create(:organization_user, organization: org, user: user, role: :member)
      other_org_project = create(:project)
      create(:organization_user, organization: other_org_project.organization, user: user, role: :member)

      create(:project_user, user: user, project: project_in_scope, role: :member)
      create(:project_user, user: user, project: other_org_project, role: :member)

      initial_scope = org.projects

      resolved_scope = described_class::Scope.new(user, initial_scope).resolve
      expect(resolved_scope).to contain_exactly(project_in_scope)
      expect(resolved_scope).not_to include(project_outside_scope)
      expect(resolved_scope).not_to include(other_org_project)
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
