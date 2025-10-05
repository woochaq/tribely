class Story < ApplicationRecord
  belongs_to :board
  belongs_to :user, optional: true
  belongs_to :owner, class_name: User.to_s
  before_validation :set_number, on: :create

  validates :title, :story_type, :status, :number, presence: true
  validates_length_of :title, maximum: 255

  after_create_commit :broadcast_on_create
  after_update_commit :broadcast_on_update
  after_destroy_commit :broadcast_on_destroy

  enum :story_type, { feature: 0, bug: 1, chore: 2, spike: 3 }, default: 0
  enum :status, { todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4 }, default: 0

  private

  def set_number
    self.number = board.present? ? (board.project.stories.maximum(:number).to_i + 1) : 1
  end

  def broadcast_on_create
    broadcast_append_to board, target: board, renderable: Components::Stories::Story.new(story: self)
    broadcast_counter_update(board)
  end

  def broadcast_on_update
    if board_id_previously_changed?
      old_board_id, _new_board_id = board_id_previous_change
      old_board = Board.find(old_board_id)

      broadcast_remove_to old_board
      broadcast_append_to board, target: board, renderable: Components::Stories::Story.new(story: self)

      broadcast_counter_update(old_board)
      broadcast_counter_update(board)
    else
      broadcast_replace_to board, renderable: Components::Stories::Story.new(story: self)
    end
  end

  def broadcast_on_destroy
    broadcast_remove_to board
    broadcast_counter_update(board)
  end

  def broadcast_counter_update(target_board)
    broadcast_replace_to(
      target_board,
      target: "stories_count_#{board.class.model_name.singular}_#{target_board.id}",
      renderable: Components::Boards::StoriesCount.new(board: target_board)
    )
  end
end
