class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  include Mentionable

  has_rich_text :content

  belongs_to :user
  belongs_to :story

  validates_presence_of :content
  validate :user_must_be_organization_owner_or_project_member

  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_destroy
  after_create_commit :send_notifications

  private

  def send_notifications
    recipients = [ story.owner, story.user ].compact.uniq
    recipients.delete(user)

    recipients.each do |recipient|
      CommentMailer.new_comment_notification(recipient: recipient, author: user, comment: self).deliver_later
    end
  end

  def broadcast_create
    broadcast_prepend_later_to(
      story.project,
      target: dom_id(story, "comments"),
      partial: "comments/comment", locals: { comment: self }
    )
  end

  def broadcast_update
    broadcast_replace_later_to(
      story.project,
      target: self,
      partial: "comments/comment", locals: { comment: self }
    )
  end

  def broadcast_destroy
    broadcast_remove_to story.project, target: self
  end

  def user_must_be_organization_owner_or_project_member
    return if user.blank? || story.blank?

    project = story.project
    organization = project.organization

    is_org_owner = user.owns_organization?(organization)
    is_project_member = project.has_member?(user)

    unless is_org_owner || is_project_member
      errors.add(:user, "must be an organization owner or a project member to comment")
    end
  end
end
