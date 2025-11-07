class Organization < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg", "image/webp", "image/avif", "image/svg+xml" ].freeze

  has_many :organization_users, inverse_of: :organization, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :projects, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates_presence_of :name
  validates :avatar, content_type: { in: ACCEPTED_CONTENT_TYPES }, size: { less_than: 1.megabytes }

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end

  def has_member?(user)
    organization_users.exists?(user: user)
  end
end
