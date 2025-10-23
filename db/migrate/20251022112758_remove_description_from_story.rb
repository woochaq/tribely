class RemoveDescriptionFromStory < ActiveRecord::Migration[8.1]
  def change
    remove_column :stories, :description, :text
  end
end
