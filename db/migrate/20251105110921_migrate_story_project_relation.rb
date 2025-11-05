class MigrateStoryProjectRelation < ActiveRecord::Migration[8.1]
  def self.up
    Story.find_each do |story|
      project = story.board&.project
      if project.present?
        story.update_column(:project_id, project.id)
      end
    end
    change_column_null :stories, :project_id, false
    add_index :stories, [ :project_id, :slug ], unique: true
  end

  def self.down
    remove_index :stories, [ :project_id, :slug ], unique: true
    change_column_null :stories, :project_id, true
  end
end
