class AddPrefixWithNumberToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :prefix_with_number, :string

    Story.find_each do |story|
      story.update_column(:prefix_with_number, "#{story.project.prefix}-#{story.number}")
    end

    add_index :stories, :prefix_with_number
  end
end
