class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :added_by, class_name: "User", optional: true

  enum :role, { owner: 0, member: 1, guest: 2 }, default: :member

  validates_presence_of :role
  validates_uniqueness_of :project_id, scope: :user_id, allow_nil: false
end
