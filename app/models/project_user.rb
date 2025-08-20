class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  enum :role, { owner: 0, member: 1 }, default: :owner

  validates_presence_of :project_id, :user_id, :role
end
