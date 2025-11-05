class Project < ApplicationRecord
  include FriendlyId
  friendly_id :prefix_and_name, use: [ :slugged, :finders ], slug_limit: 255

  validates_uniqueness_of :slug
  validates_presence_of :name, :slug, :prefix, :organization
  validates_length_of :name, :slug, maximum: 255
  validates_length_of :prefix, maximum: 10

  belongs_to :organization
  has_many :project_users, inverse_of: :project, dependent: :destroy
  has_many :users, through: :project_users
  accepts_nested_attributes_for :users
  has_many :boards, dependent: :destroy
  # has_many :stories, through: :boards
  has_many :stories, dependent: :destroy

  after_create_commit :create_default_boards

  def prefix_and_name
    "#{prefix} #{name}"
  end

  def resolve_friendly_id_conflict(candidates)
    [ candidates.first, SecureRandom.uuid.first(5) ].compact.join(friendly_id_config.sequence_separator)
  end

  def create_default_boards
    Board.kinds.keys.each do |board_kind|
      self.boards.find_or_create_by(kind: board_kind)
    end
  end

  def has_member?(user)
    project_users.exists?(user: user)
  end
end
