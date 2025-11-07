require 'rails_helper'

RSpec.describe Story, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:story_type) }
    it { should validate_length_of(:title).is_at_most(255) }

    describe "owner_and_user_must_be_members" do
      let(:project) { create(:project) }
      let(:board) { create(:board, project: project) }
      let(:project_member) { create(:user) }
      let(:non_project_member) { create(:user) }

      before do
        create(:organization_user, organization: project.organization, user: project_member)
        create(:project_user, project: project, user: project_member)
      end

      it "is valid when owner is a project member" do
        story = build(:story, board: board, owner: project_member)
        expect(story).to be_valid
      end

      it "is valid when user is a project member" do
        story = build(:story, board: board, owner: project_member, user: project_member)
        expect(story).to be_valid
      end

      it "is invalid when owner is not a project member" do
        story = build(:story, board: board, owner: non_project_member)
        expect(story).not_to be_valid
        expect(story.errors[:owner]).to include("must be a member of project")
      end

      it "is invalid when user is not a project member" do
        story = build(:story, board: board, owner: project_member, user: non_project_member)
        expect(story).not_to be_valid
        expect(story.errors[:user]).to include("must be a member of project")
      end

      it "is valid invalid when owner is nil" do
        story = build(:story, board: board, owner: nil, user: project_member)
        expect(story).not_to be_valid
      end

      it "is valid when user is nil" do
        story = build(:story, board: board, owner: project_member, user: nil)
        expect(story).to be_valid
      end

      it "is invalid when board.project is nil" do
        board = build(:board, project: nil)
        story = build(:story, board: board, owner: project_member, user: project_member)
        expect(story).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:board) }
    it { should belong_to(:owner) }
    it { should belong_to(:project) }
    it { should belong_to(:user).optional(true) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4) }
    it { should define_enum_for(:story_type).with_values(feature: 0, bug: 1, chore: 2, spike: 3) }
  end

  describe "@set_number" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project) }
    let(:board1) { create(:board, project: project) }
    let(:board2) { create(:board, project: project) }

    it "should set number for stories in project scope" do
      owner = create(:user)
      user = create(:user)
      create(:organization_user, organization: project.organization, user: owner, role: :owner)
      create(:organization_user, organization: project.organization, user: user, role: :member)
      create(:project_user, project: project, user: owner)
      create(:project_user, project: project, user: user)

      story = create(:story, board: board1, owner: owner, user: user)
      expect(story.number).to eq 1
      story2 = create(:story, board: board2, owner: owner, user: user)
      expect(story2.number).to eq 2
      story3 = create(:story, board: board2, owner: owner, user: user)
      expect(story3.number).to eq 3
      story2.destroy
      story4 = create(:story, board: board2, owner: owner, user: user)
      expect(story4.number).to eq 4
    end
  end

  describe "@handle_board_change" do
    let(:project) { create(:project) }
    let(:done_board) { create(:board, kind: :done, project: project) }
    let(:icebox_board) { create(:board, kind: :icebox, project: project) }
    let(:owner) { create(:user) }
    let(:user) { create(:user) }
    before do
      create(:organization_user, organization: project.organization, user: owner, role: :owner)
      create(:organization_user, organization: project.organization, user: user, role: :member)
      create(:project_user, project: project, user: owner)
      create(:project_user, project: project, user: user)
    end
    let!(:story) { create(:story, board: icebox_board, owner: owner, user: user) }

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
    let(:owner) { create(:user) }
    let(:user) { create(:user) }
    before do
      create(:organization_user, organization: project.organization, user: owner, role: :owner)
      create(:organization_user, organization: project.organization, user: user, role: :member)
      create(:project_user, project: project, user: owner)
      create(:project_user, project: project, user: user)
    end
    let(:story) { build(:story, board: board, owner: owner, user: user) }

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

  describe 'FriendlyId and Custom Slug' do
    let(:organization) { create(:organization) }
    let(:project1) { create(:project, organization: organization, prefix: 'PROJ1') }
    let(:project2) { create(:project, organization: organization, prefix: 'PROJ1') }
    let(:board1) { create(:board, project: project1) }
    let(:board2) { create(:board, project: project2) }
    let(:member) { create(:user) }

    before do
      create(:organization_user, organization: organization, user: member)
      create(:project_user, project: project1, user: member)
      create(:project_user, project: project2, user: member)
    end

    context 'slug generation' do
      it 'generates a slug based on the project prefix and story number' do
        story = create(:story, board: board1, owner: member)
        expect(story.slug).to eq("proj1-#{story.number}")
        story = create(:story, board: board2, owner: member)
        expect(story.slug).to eq("proj1-#{story.number}")
      end

      it 'do not updates the slug if the story number changes' do
        story = create(:story, board: board1, owner: member)
        number = story.number
        story.update(number: 124)
        expect(story.slug).to eq("proj1-#{number}")
      end
    end

    context 'finding records' do
      it 'can be found by its friendly id' do
        story = create(:story, board: board1, owner: member)
        found_story = Story.friendly.find("PROJ1-#{story.number}")
        expect(found_story).to eq(story)
      end
    end

    context 'scoped uniqueness' do
      it 'allows two stories with the same number in different projects' do
        story1 = create(:story, board: board1, owner: member)
        story2 = create(:story, board: board2, owner: member)

        expect(story1).to be_valid
        expect(story2).to be_valid
        expect(story1.slug).to eq("proj1-#{story1.number}")
        expect(story2.slug).to eq("proj1-#{story2.number}")
      end
    end
  end

  describe "#move_to_top_if_started" do
    let(:project) { create(:project) }
    let(:board) { create(:board, project: project) }
    let(:owner) { create(:user) }

    before do
      create(:organization_user, organization: project.organization, user: owner)
      create(:project_user, project: project, user: owner)
    end

    it "moves the story to the top of the list when status changes from todo to in_progress" do
      story1 = create(:story, board: board, owner: owner, status: :todo)
      story2 = create(:story, board: board, owner: owner, status: :todo)
      story3 = create(:story, board: board, owner: owner, status: :todo)

      expect(story1.position).to eq(1)
      expect(story2.position).to eq(2)
      expect(story3.position).to eq(3)

      story3.update(status: :in_progress)

      expect(story3.reload.position).to eq(1)
      expect(story2.reload.position).to eq(3)
      expect(story1.reload.position).to eq(2)
    end

    it "does not move the story if the status changes to something else" do
      story1 = create(:story, board: board, owner: owner, status: :todo)
      story2 = create(:story, board: board, owner: owner, status: :todo)
      story3 = create(:story, board: board, owner: owner, status: :todo)

      expect(story1.position).to eq(1)
      expect(story2.position).to eq(2)
      expect(story3.position).to eq(3)

      story3.update(status: :done)

      expect(story3.reload.position).to eq(3)
      expect(story2.reload.position).to eq(2)
      expect(story1.reload.position).to eq(1)
    end

    it "does not move the story if the status was not todo" do
      story1 = create(:story, board: board, owner: owner, status: :in_review)
      story2 = create(:story, board: board, owner: owner, status: :in_review)
      story3 = create(:story, board: board, owner: owner, status: :in_review)

      expect(story1.position).to eq(1)
      expect(story2.position).to eq(2)
      expect(story3.position).to eq(3)

      story3.update(status: :in_progress)

      expect(story3.reload.position).to eq(3)
      expect(story2.reload.position).to eq(2)
      expect(story1.reload.position).to eq(1)
    end
  end
end
