class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { owner: 0,  member: 1, guest: 2 }, default: :member

  validates_uniqueness_of :organization_id, scope: :user_id, allow_nil: false
  validates_presence_of :role, :user_id

  after_destroy :remove_user_from_organization_projects

  private

  def remove_user_from_organization_projects
    organization.projects.each do |project|
      project.project_users.where(user: user).destroy_all
    end
  end
end
