class Story < ApplicationRecord
  belongs_to :board
  belongs_to :user, optional: true
  belongs_to :owner, class_name: User.to_s
  before_validation :set_number, on: :create

  validates :title, :story_type, :status, :number, presence: true
  validates_length_of :title, maximum: 255

  after_create_commit -> { broadcast_append_to board, target: board, renderable: Components::Stories::Story.new(story: self) }
  after_update_commit -> { broadcast_replace_to board, target: self, renderable: Components::Stories::Story.new(story: self) }
  after_destroy_commit -> { broadcast_remove_to board }

  enum :story_type, { feature: 0, bug: 1, chore: 2, spike: 3 }, default: 0
  enum :status, { todo: 0, in_progress: 1, in_review: 2, done: 3, archived: 4 }, default: 0

  private

  def set_number
    self.number = board.present? ? (board.project.stories.maximum(:number).to_i + 1) : 1
  end
end
