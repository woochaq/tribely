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

  describe "@handle_board_change" do
    let(:project) { create(:project) }
    let(:done_board) { create(:board, kind: :done, project: project) }
    let(:icebox_board) { create(:board, kind: :icebox, project: project) }
    let!(:story) { create(:story, board: icebox_board) }

    context "when moveing story between Done and Icebox" do
      it "should change status to done and set done_at" do
        expect(story.status).to eq("todo")
        expect(story.done_at).to be_nil
        story.update(board: done_board)
        expect(story.status).to eq("done")
        expect(story.done_at).to be_present
        story.update(board: icebox_board)
        expect(story.status).to eq("todo")
        expect(story.done_at).to be_nil
      end
    end
  end

  describe 'broadcasts' do
    let(:project) { create(:project) }
    let(:board) { create(:board, project: project) }
    let(:story) { build(:story, board: board) }

    it 'broadcasts an update on create' do
      expect(story).to receive(:broadcast_update_to).with(
        project, # Cel (streamable)
        target: "board_#{board.id}", # ID DOM celu
        renderable: an_instance_of(Components::Boards::StoriesList) # Sprawdza, czy to poprawna klasa
      )
      story.save!
    end

    it 'broadcasts an update on update' do
      story.save!
      expect(story).to receive(:broadcast_update_to).with(
        project, # Cel (streamable)
        target: "board_#{board.id}", # ID DOM celu
        renderable: an_instance_of(Components::Boards::StoriesList) # Sprawdza, czy to poprawna klasa
      )
      story.update!(title: 'New Title')
    end

    it 'broadcasts an update on destroy' do
      story.save!
      expect(story).to receive(:broadcast_update_to).with(
        project, # Cel (streamable)
        target: "board_#{board.id}", # ID DOM celu
        renderable: an_instance_of(Components::Boards::StoriesList) # Sprawdza, czy to poprawna klasa
      )
      story.destroy!
    end

    it 'broadcasts an update to both old and new boards when board_id changes' do
      story.save!
      new_board = create(:board, project: project)

      expect(story).to receive(:broadcast_update_to).with(
        project,
        target: "board_#{board.id}",
        renderable: an_instance_of(Components::Boards::StoriesList)
      ).ordered

      expect(story).to receive(:broadcast_update_to).with(
        project,
        target: "board_#{new_board.id}",
        renderable: an_instance_of(Components::Boards::StoriesList)
      ).ordered

      story.update!(board: new_board)
    end
  end
end
