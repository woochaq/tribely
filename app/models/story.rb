class Story < ApplicationRecord
  extend FriendlyId

  acts_as_list scope: :board
  has_rich_text :description

  belongs_to :board
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :owner, class_name: User.to_s
  has_many :comments, dependent: :destroy

  friendly_id :custom_slug, use: :scoped, scope: :project

  before_validation :set_project
  before_validation :set_number, on: :create
  validates_presence_of :title, :story_type, :status, :number, :project
  validates_length_of :title, maximum: 255
  validate :owner_and_user_must_be_members
  validate :board_must_belong_to_project

  enum :story_type, { feature: 0, bug: 1, chore: 2, spike: 3 }, default: 0
  enum :status, { todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4 }, default: 0

  after_create_commit  -> { broadcast_project_update(board) }
  after_update_commit  :broadcast_on_update
  after_destroy_commit -> { broadcast_project_update(board) }

  before_save :move_to_top_if_started
  before_save :handle_board_change, if: -> { board_id_changed? }

  private

  def owner_and_user_must_be_members
    return if project.nil?
    if owner.present? && !project.has_member?(owner)
      errors.add(:owner, "must be a member of project")
    end
    if user.present? && !board.project.has_member?(user)
      errors.add(:user, "must be a member of project")
    end
  end

  def set_number
    return if project.nil?
    self.number = board.present? ? (project.stories.maximum(:number).to_i + 1) : 1
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

  def set_project
    self.project = board.project if board.present?
  end

  def custom_slug
    "#{project&.prefix}-#{number}"
  end

  def board_must_belong_to_project
    return unless board_id_changed? && board.present? && project_id_was.present?
    errors.add(:board, "must belong to the story's project") if board.project_id != self.project_id_was
  end

  def move_to_top_if_started
    if status_changed? && status_was == "todo" && in_progress?
      self.position = 1
    end
  end
end
