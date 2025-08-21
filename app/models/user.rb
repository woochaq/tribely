class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :full_name, length: { maximum: 100 }

  has_many :project_users, inverse_of: :user, dependent: :destroy
  has_many :projects, through: :project_users

  def initials
    initial_name = full_name.present? ? full_name : email
    parts = initial_name.split
    if parts.size == 1
      parts.first[0, 2].upcase
    else
      [ parts.first[0], parts.last[0] ].join.upcase
    end
  end
end
