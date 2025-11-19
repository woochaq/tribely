class Webhook < ApplicationRecord
  belongs_to :project
  belongs_to :board
  belongs_to :created_by, class_name: "User"

  has_secure_token

  enum :webhook_type, { create_story: 0 }, default: :create_story

  validates :name, presence: true
  validates :board, presence: true
  validate :board_must_belong_to_project
  validate :creator_must_be_project_owner

  scope :active, -> { where(active: true) }

  private

  def board_must_belong_to_project
    return if board.nil? || project.nil?
    if board.project_id != project_id
      errors.add(:board, "must belong to the project")
    end
  end

  def creator_must_be_project_owner
    return if created_by.nil? || project.nil?
    unless project.project_users.exists?(user: created_by, role: :owner)
      errors.add(:created_by, "must be a project owner")
    end
  end
end
