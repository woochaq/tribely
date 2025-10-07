class AddPositionToStory < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :position, :integer, null: false
  end
end
