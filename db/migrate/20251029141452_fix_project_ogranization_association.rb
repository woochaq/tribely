class FixProjectOgranizationAssociation < ActiveRecord::Migration[8.1]
  def self.up
    Project.find_each do |project|
      organization = project.project_users.owner.first.user.organization_users.owner.first
      if organization
        project.update_column(:organization_id, organization.id)
      end
    end

    change_column_null :projects, :organization_id, false
  end

  def self.down
  end
end
