class Project < ApplicationRecord
  include FriendlyId
  friendly_id :prefix_and_name, use: [ :slugged, :finders ], slug_limit: 255

  DEFAULT_BOARDS = [ "Current", "Backlog", "Icebox", "Done" ]

  validates_uniqueness_of :slug
  validates_presence_of :name, :slug, :prefix
  validates_length_of :name, :slug, maximum: 255
  validates_length_of :prefix, maximum: 10

  has_many :project_users, inverse_of: :project, dependent: :destroy
  has_many :users, through: :project_users
  accepts_nested_attributes_for :users
  has_many :boards, dependent: :destroy
  has_many :stories, through: :boards

  after_create_commit :create_default_boards

  def prefix_and_name
    "#{prefix} #{name}"
  end

  def resolve_friendly_id_conflict(candidates)
    [ candidates.first, SecureRandom.uuid.first(5) ].compact.join(friendly_id_config.sequence_separator)
  end

  def create_default_boards
    DEFAULT_BOARDS.each do |board_name|
      self.boards.find_or_create_by(name: board_name)
    end
  end
end
