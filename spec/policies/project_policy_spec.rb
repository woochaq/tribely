require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  let(:user1) { FactoryBot.create(:user) }
  let!(:project1) { FactoryBot.create(:project, project_users: [ FactoryBot.build(:project_user, user: user1, role: :owner) ]) }

  let(:member_user1) { FactoryBot.create(:user) }
  let!(:project_member_association) { FactoryBot.create(:project_user, user: member_user1, project: project1, role: :member) }

  let(:user2) { FactoryBot.create(:user) }
  let!(:project2) { FactoryBot.create(:project, project_users: [ FactoryBot.build(:project_user, user: user2, role: :owner) ]) }

  let(:lonely_user) { FactoryBot.create(:user) }

  subject { described_class }

  permissions :index? do
    it "grants access to everybody" do
      expect(subject).to permit(user1, Project)
      expect(subject).to permit(member_user1, Project)
      expect(subject).to permit(user2, Project)
      expect(subject).to permit(lonely_user, Project)
    end
  end

  permissions :show? do
    it "grants access if the project belongs to the user (owner or member)" do
      expect(subject).to permit(user1, project1)
      expect(subject).to permit(member_user1, project1)
    end

    it "denies access if the project does not belong to the user" do
      expect(subject).not_to permit(user2, project1)
      expect(subject).not_to permit(lonely_user, project1)
    end
  end

  permissions :new?, :create? do
    it "grants access to everybody" do
      expect(subject).to permit(user1, Project)
      expect(subject).to permit(member_user1, Project)
      expect(subject).to permit(user2, Project)
      expect(subject).to permit(lonely_user, Project)
    end
  end

  permissions :edit?, :update?, :destroy? do
    it "grants access to the project owner" do
      expect(subject).to permit(user1, project1)
    end

    it "denies access to a project member" do
      expect(subject).not_to permit(member_user1, project1)
    end

    it "denies access if the project does not belong to the user" do
      expect(subject).not_to permit(user2, project1)
      expect(subject).not_to permit(lonely_user, project1)
    end
  end

  describe "Scope" do
    subject { described_class::Scope.new(user, scope).resolve }

    let(:scope) { Project.all }

    context "for a project owner (user1)" do
      let(:user) { user1 }

      it "includes projects the user owns" do
        expect(subject).to contain_exactly(project1)
      end
    end

    context "for a project member (member_user1)" do
      let(:user) { member_user1 }

      it "includes projects the user is a member of" do
        expect(subject).to contain_exactly(project1)
      end
    end

    context "for a user not associated with project1 (user2)" do
      let(:user) { user2 }

      it "includes projects the user owns and excludes others" do
        expect(subject).to contain_exactly(project2)
        expect(subject).not_to include(project1)
      end
    end

    context "for a user with no projects (lonely_user)" do
      let(:user) { lonely_user }

      it "returns an empty scope" do
        expect(subject).to be_empty
      end
    end
  end
end
