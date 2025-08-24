class Organization < ApplicationRecord
  has_many :organization_users, inverse_of: :organization, dependent: :destroy
  has_many :users, through: :organization_users

  validates_presence_of :name
end
