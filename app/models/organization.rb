class Organization < ApplicationRecord
  has_many :organization_users, inverse_of: :organization, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :projects, dependent: :destroy

  validates_presence_of :name
end
