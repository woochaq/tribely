class Integration < ApplicationRecord
  TYPES = %w[Integrations::Slack].freeze

  belongs_to :project
  belongs_to :created_by, class_name: "User"

  scope :active, -> { where(active: true) }

  validates_presence_of :name, :type
  validates :type, inclusion: { in: TYPES }

  def self.available_types
    TYPES.map { |type| [ type.demodulize, type ] }
  end
end
