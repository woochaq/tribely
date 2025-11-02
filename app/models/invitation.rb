class Invitation < ApplicationRecord
  belongs_to :organization
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User", optional: true

  has_secure_token

  enum :status, { pending: 0, accepted: 1, expired: 2 }, default: :pending
  enum :role, { owner: 0, member: 1, guest: 2 }, default: :member

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :organization_id, conditions: -> { where(status: :pending) } }
  validates :organization_id, presence: true
  validate :recipient_is_not_a_member
  validate :sender_is_a_member

  private

  def recipient_is_not_a_member
    return unless organization.present?
    if organization.users.exists?(email: email)
      errors.add(:email, "is already a member of this organization")
    end
  end

  def sender_is_a_member
    return unless organization.present?
    unless organization.users.include?(sender)
      errors.add(:sender, "must be a member of the organization")
    end
  end
end
