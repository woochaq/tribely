class Board < ApplicationRecord
  belongs_to :project
  has_many :stories, dependent: :destroy

  validates_presence_of :kind

  enum :kind, { current: 0, backlog: 1, icebox: 2, done: 3 }, default: 0
end
