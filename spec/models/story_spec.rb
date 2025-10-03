require 'rails_helper'

RSpec.describe Story, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:story_type) }
    it { should validate_length_of(:title).is_at_most(255) }
  end

  describe 'associations' do
    it { should belong_to(:board) }
    it { should belong_to(:owner) }
    it { should belong_to(:user).optional(true) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4) }
    it { should define_enum_for(:story_type).with_values(feature: 0, bug: 1, chore: 2, spike: 3) }
  end

  describe "@set_number" do
    let(:project) { create(:project) }
    let(:board1) { create(:board, project: project) }
    let(:board2) { create(:board, project: project) }

    it "should set number for stories in project scope" do
      story = create(:story, board: board1)
      expect(story.number).to eq 1
      story2 = create(:story, board: board2)
      expect(story2.number).to eq 2
      story3 = create(:story, board: board2)
      expect(story3.number).to eq 3
      story2.destroy
      story4 = create(:story, board: board2)
      expect(story4.number).to eq 4
    end
  end
end
