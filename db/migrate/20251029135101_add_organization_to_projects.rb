class AddOrganizationToProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :projects, :organization, null: true, foreign_key: true
  end
end
