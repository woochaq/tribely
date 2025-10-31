class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum :role, { owner: 0, member: 1 }, default: :owner

  validates_presence_of :role
  validates_uniqueness_of :project_id, scope: :user_id, allow_nil: false
end
