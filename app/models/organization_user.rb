class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { owner: 0,  member: 1, guest: 2 }, default: :member

  validates_uniqueness_of :organization_id, scope: :user_id, allow_nil: false
  validates_presence_of :role, :user_id

  after_destroy :remove_user_from_organization_projects
  after_destroy :cleanup_organization_data

  private

  def cleanup_organization_data
    Story.joins(:project).where(projects: { organization_id: organization_id }, user_id: user_id).update_all(user_id: nil)

    organization.projects.each do |project|
      stories_to_fix = project.stories.where(owner_id: user_id)
      next unless stories_to_fix.exists?

      new_owner = project.project_users.owner.where.not(user_id: user_id).first&.user
      new_owner ||= organization.organization_users.owner.where.not(user_id: user_id).first&.user
      stories_to_fix.update_all(owner_id: new_owner&.id)
    end

    organization.invitations.pending.where(sender_id: user_id).destroy_all
    organization.invitations.pending.where(email: user.email).destroy_all
  end

  def remove_user_from_organization_projects
    organization.projects.each do |project|
      project.project_users.where(user: user).destroy_all
    end
  end
end
