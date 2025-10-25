class Story < ApplicationRecord
  acts_as_list scope: :board
  has_rich_text :description

  belongs_to :board
  belongs_to :user, optional: true
  belongs_to :owner, class_name: User.to_s
  has_many :comments, dependent: :nullify

  before_validation :set_number, on: :create
  validates_presence_of :title, :story_type, :status, :number
  validates_length_of :title, maximum: 255

  enum :story_type, { feature: 0, bug: 1, chore: 2, spike: 3 }, default: 0
  enum :status, { todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4 }, default: 0

  after_create_commit  -> { broadcast_board_update(board) }
  after_update_commit  :broadcast_on_update
  after_destroy_commit -> { broadcast_board_update(board) }

  private

  def set_number
    self.number = board.present? ? (board.project.stories.maximum(:number).to_i + 1) : 1
  end

  def broadcast_on_update
    if board_id_previously_changed?
      old_board_id, _new_board_id = board_id_previous_change
      old_board = Board.find(old_board_id)

      broadcast_board_update(old_board)
      broadcast_board_update(board)
    else
      broadcast_board_update(board)
    end
  end

  def broadcast_board_update(target_board)
    broadcast_replace_to(
      target_board,
      target: "board_#{target_board.id}",
      renderable: Components::Boards::StoriesList.new(board: target_board)
    )
  end
end
