class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :added_by, class_name: "User", optional: true

  enum :role, { owner: 0, member: 1, guest: 2 }, default: :member

  validates_presence_of :role
  validates_uniqueness_of :project_id, scope: :user_id, allow_nil: false
  validate :check_if_user_belongs_to_organization

  after_create_commit :send_added_to_project_email

  def send_added_to_project_email
    ProjectMemberMailer.added_to_project_email(self).deliver_later if added_by.present?
  end

  def check_if_user_belongs_to_organization
    return true if user.nil?
    unless project.organization.organization_users.exists?(user: user)
      errors.add(:user, "must belongs to organization")
    end
  end
end
