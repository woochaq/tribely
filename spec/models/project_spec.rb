require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:prefix) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:slug).is_at_most(255) }
    it { should validate_length_of(:prefix).is_at_most(10) }
    it { should validate_length_of(:slug) }
    it { should validate_length_of(:prefix) }
  end

  describe "associations" do
    it { should have_many(:users) }
    it { should belong_to(:organization) }
  end

  describe "@friendly_id" do
    it "should create uniqe slugs" do
      project1 = create(:project, name: "Tribely", prefix: "TR")
      project2 = create(:project, name: "Pin Post", prefix: "PP")
      project3 = create(:project, name: "Pin Post", prefix: "PP")

      expect(project1.slug).to eq("tr-tribely")
      expect(project2.slug).to eq("pp-pin-post")
      expect(project3.slug).to include("pp-pin-post-")
    end
  end

  describe "@has_member?" do
    let(:project) { create(:project) }
    let(:org_user) { create(:user) }
    let(:member_user) { create(:user) }
    let(:member_owner_user) { create(:user) }
    let(:member_guest_user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      organization = project.organization
      create(:organization_user, organization: organization, user: org_user, role: :owner)
      create(:organization_user, organization: organization, user: member_user, role: :member)
      create(:organization_user, organization: organization, user: member_owner_user, role: :member)
      create(:organization_user, organization: organization, user: member_guest_user, role: :guest)
      create(:project_user, project: project, user: member_user, role: :member)
      create(:project_user, project: project, user: member_owner_user, role: :owner)
      create(:project_user, project: project, user: member_guest_user, role: :guest)
    end

    it "should check if project has mamber any type of" do
      expect(project.has_member?(org_user)).to be_falsy
      expect(project.has_member?(member_user)).to be_truthy
      expect(project.has_member?(member_owner_user)).to be_truthy
      expect(project.has_member?(member_guest_user)).to be_truthy
      expect(project.has_member?(other_user)).to be_falsy
    end
  end

  describe "@create_default_board" do
    let(:project) { create(:project, name: "Tribely", prefix: "TR") }

    it "should create default boards on create" do
      expect(project.boards.count).to eq(4)
      expect(project.boards.map(&:kind)).to eq(Board.kinds.keys)
    end
  end
end
