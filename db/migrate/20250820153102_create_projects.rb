class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :prefix, null: false
      t.string :slug, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
