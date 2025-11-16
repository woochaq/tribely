class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title
      t.references :created_by, null: true, foreign_key: { to_table: :users }
      t.references :last_updated_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
