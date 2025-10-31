class OrganizationUser < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { owner: 0,  member: 1, guest: 2 }, default: :member

  validates_uniqueness_of :organization_id, scope: :user_id, allow_nil: false
  validates_presence_of :role, :user_id
end
