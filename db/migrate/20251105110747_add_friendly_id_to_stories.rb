class AddFriendlyIdToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :slug, :string
    add_reference :stories, :project, null: true, foreign_key: true
  end
end
