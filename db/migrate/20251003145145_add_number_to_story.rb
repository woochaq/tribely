class AddNumberToStory < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :number, :integer, null: false
  end
end
