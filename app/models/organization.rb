class Organization < ApplicationRecord
  has_many :organization_users, inverse_of: :organization, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :projects, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates_presence_of :name

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
end
