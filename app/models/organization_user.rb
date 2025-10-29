class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { owner: 0,  member: 1 }, default: :member

  validates_presence_of :role
end
