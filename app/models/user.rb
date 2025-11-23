class User < ApplicationRecord
  include ActionText::Attachable

  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg", "image/webp", "image/avif", "image/svg+xml" ].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :full_name, length: { maximum: 100 }
  has_many :notifications, as: :recipient, dependent: :destroy

  has_many :project_users, inverse_of: :user, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :comments, dependent: :nullify
  has_many :organization_users, inverse_of: :user, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id", dependent: :destroy
  has_many :received_invitations, class_name: "Invitation", foreign_key: "recipient_id", dependent: :destroy
  has_many :added_project_users, class_name: "ProjectUser", foreign_key: "added_by_id", dependent: :nullify, inverse_of: :added_by
  has_many :stories_as_last_updater, class_name: "Story", foreign_key: "last_updated_by_id", dependent: :nullify
  has_many :created_documents, class_name: "Document", foreign_key: "created_by_id", dependent: :nullify
  has_many :updated_documents, class_name: "Document", foreign_key: "last_updated_by_id", dependent: :nullify
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"

  validates :avatar, content_type: { in: ACCEPTED_CONTENT_TYPES }, size: { less_than: 1.megabytes }

  after_create_commit :create_default_organization

  def content_type
    "application/vnd.actiontext.mention"
  end

  def initials
    initial_name = full_name.present? ? full_name : email
    parts = initial_name.split
    if parts.size == 1
      parts.first[0, 2].upcase
    else
      [ parts.first[0], parts.last[0] ].join.upcase
    end
  end

  def name
    full_name.presence || email
  end

  def all_projects
    owner_organization_ids = organization_users.owner.pluck(:organization_id)
    Project.where(id: self.project_ids).or(Project.where(organization_id: owner_organization_ids)).distinct
  end

  def owns_organization?(organization)
    organization_users.exists?(organization: organization, role: :owner)
  end

  def owns_project?(project)
    project_users.exists?(project: project, role: :owner)
  end

  private

  def create_default_organization
    organization = Organization.new(name: "#{email.split("@").first.titleize} Workspace")
    organization.organization_users.new(user: self, role: :owner)
    organization.save
  end
end
