class Story < ApplicationRecord
  acts_as_list scope: :board
  has_rich_text :description

  belongs_to :board
  belongs_to :user, optional: true
  belongs_to :owner, class_name: User.to_s
  has_many :comments, dependent: :destroy

  before_validation :set_number, on: :create
  validates_presence_of :title, :story_type, :status, :number
  validates_length_of :title, maximum: 255
  validate :owner_and_user_must_be_members

  enum :story_type, { feature: 0, bug: 1, chore: 2, spike: 3 }, default: 0
  enum :status, { todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4 }, default: 0

  after_create_commit  -> { broadcast_project_update(board) }
  after_update_commit  :broadcast_on_update
  after_destroy_commit -> { broadcast_project_update(board) }

  before_save :handle_board_change, if: -> { board_id_changed? }

  private

  def owner_and_user_must_be_members
    if owner.present? && !board.project.project_users.exists?(user: owner)
      errors.add(:owner, "must be a member of project")
    end
    if user.present? && !board.project.project_users.exists?(user: user)
      errors.add(:user, "must be a member of project")
    end
  end

  def set_number
    self.number = board.present? ? (board.project.stories.maximum(:number).to_i + 1) : 1
  end

  def broadcast_on_update
    if board_id_previously_changed?
      old_board_id, _new_board_id = board_id_previous_change
      old_board = Board.find(old_board_id)

      broadcast_project_update(old_board)
      broadcast_project_update(board)
    else
      broadcast_project_update(board)
    end
  end

  def broadcast_project_update(target_board)
    broadcast_update_to(
      target_board.project,
      target: "board_#{target_board.id}",
      renderable: Components::Boards::StoriesList.new(board: target_board)
    )
  end

  def handle_board_change
    if board_id_changed?
      if board.done?
        self.done_at = Time.current
        self.status = :done
      elsif board.icebox?
        self.done_at = nil
        self.status = :todo
      end
    end
  end
end
