class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: true, foreign_key: { to_table: :users }
      t.string :email, null: false
      t.string :token
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :invitations, :token, unique: true
    add_index :invitations, [:organization_id, :email], unique: true
  end
end
