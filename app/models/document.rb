class Document < ApplicationRecord
  include ActionText::Attachable
  include Mentionable
  extend FriendlyId
  friendly_id :custom_slug, use: :scoped, scope: :project

  has_rich_text :content

  belongs_to :project
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :last_updated_by, class_name: "User", optional: true

  validates_presence_of :title
  validates_length_of :title, maximum: 255

  validate :creator_must_be_valid_member, on: :create
  validate :last_updated_by_must_be_valid_member, on: %i[create update]


  scope :search, ->(query) { where("LOWER(title) LIKE LOWER(?)", "%#{query}%") }

  def content_type
    "application/vnd.actiontext.document_mention"
  end

  private

    def creator_must_be_valid_member
      return if created_by.nil? || project.nil?
      errors.add(:created_by, "is not a valid member") unless is_valid_member?(created_by)
    end

    def last_updated_by_must_be_valid_member
      return if last_updated_by.nil? || project.nil?
      errors.add(:last_updated_by, "is not a valid member") unless is_valid_member?(last_updated_by)
    end

    def is_valid_member?(user)
      is_project_member_but_not_guest = project.project_users.where(user: user).where.not(role: "guest").exists?
      is_org_owner = user.owns_organization?(project.organization)

      is_project_member_but_not_guest || is_org_owner
    end

    def custom_slug
      "#{project&.prefix}-#{title}"
    end
end
