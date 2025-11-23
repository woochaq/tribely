require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(128) }
    it { should validate_content_type_of(:avatar).allowing(User::ACCEPTED_CONTENT_TYPES) }
    it { should validate_size_of(:avatar).less_than(1.megabyte) }

    it "should have a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:organization_users) }
    it { should have_many(:organizations) }
    it { should have_many(:sent_invitations) }
    it { should have_many(:received_invitations) }
    it { should have_many(:added_project_users).class_name('ProjectUser').with_foreign_key('added_by_id').dependent(:nullify) }
    it { should have_many(:notifications).class_name('Noticed::Notification').dependent(:destroy) }
  end

  describe "@initials" do
    let(:user) { build(:user, email: "example@gmail.com", full_name: full_name) }
    subject { user.initials }

    context "when full_name is a single word" do
      let(:full_name) { "John" }
      it { is_expected.to eq("JO") }
    end

    context "when full_name is single character" do
      let(:full_name) { "J" }
      it { is_expected.to eq("J") }
    end

    context "when full_name is two words" do
      let(:full_name) { "John Doe" }
      it { is_expected.to eq("JD") }
    end

    context "when full_name has more than two words" do
      let(:full_name) { "John Doe Smith" }
      it { is_expected.to eq("JS") }
    end

    context "when full_name is empty" do
      let(:full_name) { "" }
      it { is_expected.to eq("EX") }
    end
  end

  describe "@name" do
    let(:user) { build(:user, email: "example@gmail.com", full_name: full_name) }
    subject { user.name }

    context "when full_name is present" do
      let(:full_name) { "John Doe" }
      it { is_expected.to eq("John Doe") }
    end

    context "when full_name is not present" do
      let(:full_name) { "" }
      it { is_expected.to eq("example@gmail.com") }
    end
  end

  describe "@all_projects" do
    let(:owner) { create(:user) }
    let(:organization) { owner.organization_users.owner.first.organization }
    let(:project) { create(:project, organization: organization) }
    let(:project2) { create(:project, organization: organization, project_users: [ build(:project_user, user: owner, role: :owner) ]) }
    let(:project3) { create(:project, organization: organization, project_users: [ build(:project_user, user: owner, role: :member) ]) }

    it "should return all projects event not assigned to user owner" do
      expect(owner.all_projects).to contain_exactly(project, project2, project3)
    end
  end

  describe "@create_default_organization" do
    it "should create default organization for user after create" do
      user = create(:user, email: "john.cena@google.com")
      expect(user.organizations.count).to eq 1
      expect(user.organizations.first.name).to eq "John.Cena Workspace"
      expect(user.organization_users.first.role).to eq "owner"
    end
  end

  describe "#owns_organization?" do
    let(:organization) { create(:organization) }
    let(:owner) { create(:user) }
    let(:member) { create(:user) }
    let(:unrelated_user) { create(:user) }

    before do
      create(:organization_user, organization: organization, user: owner, role: :owner)
      create(:organization_user, organization: organization, user: member, role: :member)
    end

    it "returns true if the user is an owner of the organization" do
      expect(owner.owns_organization?(organization)).to be true
    end

    it "returns false if the user is a member but not an owner" do
      expect(member.owns_organization?(organization)).to be false
    end

    it "returns false if the user is not associated with the organization" do
      expect(unrelated_user.owns_organization?(organization)).to be false
    end
  end

  describe "@owns_project?" do
    let(:project) { create(:project) }
    let(:owner) { create(:user) }
    let(:member) { create(:user) }

    before do
      create(:organization_user, organization: project.organization, user: owner, role: :owner)
      create(:organization_user, organization: project.organization, user: member, role: :member)
      create(:project_user, project: project, user: owner, role: :owner)
      create(:project_user, project: project, user: member, role: :member)
    end

    it "returns true if the user is an owner of the project" do
      expect(owner.owns_project?(project)).to be true
    end

    it "returns false if the user is a member of the project" do
      expect(member.owns_project?(project)).to be false
    end
  end


  describe "@content_type" do
    it "returns actiontext.mention for lexxy editor" do
      expect(described_class.new.content_type).to eq ("application/vnd.actiontext.mention")
    end
  end
end
