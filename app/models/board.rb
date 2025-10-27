class Board < ApplicationRecord
  belongs_to :project
  has_many :stories, dependent: :destroy

  validates_presence_of :name

  def done?
    name == "Done"
  end

  def icebox?
    name == "Icebox"
  end
end
