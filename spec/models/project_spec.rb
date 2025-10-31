require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:prefix) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:slug).is_at_most(255) }
    it { should validate_length_of(:prefix).is_at_most(10) }
    it { should validate_length_of(:slug) }
    it { should validate_length_of(:prefix) }
  end

  describe 'associations' do
    it { should have_many(:users) }
    it { should belong_to(:organization) }
  end

  describe '#friendly_id' do
    it "should create uniqe slugs" do
      project1 = create(:project, name: "Tribely", prefix: "TR")
      project2 = create(:project, name: "Pin Post", prefix: "PP")
      project3 = create(:project, name: "Pin Post", prefix: "PP")

      expect(project1.slug).to eq("tr-tribely")
      expect(project2.slug).to eq("pp-pin-post")
      expect(project3.slug).to include("pp-pin-post-")
    end
  end

  describe '@create_default_board' do
    let(:project) { create(:project, name: "Tribely", prefix: "TR") }

    it "should create default boards on create" do
      expect(project.boards.count).to eq(4)
      expect(project.boards.map(&:kind)).to eq(Board.kinds.keys)
    end
  end
end
