class RemoveUniqueEmailIndexFromInvitations < ActiveRecord::Migration[8.1]
  def change
    remove_index :invitations, name: "index_invitations_on_organization_id_and_email"
  end
end
