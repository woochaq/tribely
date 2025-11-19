class CreateWebhooks < ActiveRecord::Migration[8.1]
  def change
    create_table :webhooks do |t|
      t.references :project, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :token, null: false
      t.string :name
      t.boolean :active, default: true, null: false
      t.datetime :last_triggered_at

      t.timestamps
    end
    add_index :webhooks, :token, unique: true
  end
end
