class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { owner: 0, admin: 1, member: 2 }, default: :member

  validates_presence_of :role
end
