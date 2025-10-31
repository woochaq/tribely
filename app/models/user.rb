class User < ApplicationRecord
  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg", "image/webp", "image/avif", "image/svg+xml" ].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :full_name, length: { maximum: 100 }

  has_many :project_users, inverse_of: :user, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :comments, dependent: :nullify
  has_many :organization_users, inverse_of: :user, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  validates :avatar, content_type: { in: ACCEPTED_CONTENT_TYPES }, size: { less_than: 1.megabytes }

  after_create_commit :create_default_organization

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
