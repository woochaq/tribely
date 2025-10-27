class AddDoneAtToStory < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :done_at, :datetime
  end
end
