class CreateIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :integrations do |t|
      t.references :project, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.string :type
      t.string :name
      t.json :settings
      t.json :events
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
