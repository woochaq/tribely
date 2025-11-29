class Integration < ApplicationRecord
  TYPES = %w[Integrations::Slack].freeze
  AVAILABLE_EVENTS = %w[story_created story_assigned comment_created].freeze

  belongs_to :project
  belongs_to :created_by, class_name: "User"

  scope :active, -> { where(active: true) }

  validates_presence_of :name, :type
  validates :type, inclusion: { in: TYPES }
  validate :validate_events

  before_validation :clean_events

  def self.available_types
    TYPES.map { |type| [ type.demodulize, type ] }
  end

  def self.available_events
    AVAILABLE_EVENTS.map { |event| [ event.humanize, event ] }
  end

  def test_notifier_class
    raise NotImplementedError, "Subclasses must implement test_notifier_class"
  end

  private

  def clean_events
    self.events = events.reject(&:blank?) if events.is_a?(Array)
  end

  def validate_events
    return if events.nil? || events.empty?
    unless events.is_a?(Array)
      errors.add(:events, "must be a list of events")
      return
    end

    invalid_events = events - AVAILABLE_EVENTS
    if invalid_events.any?
      errors.add(:events, "contains invalid events: #{invalid_events.join(', ')}")
    end
  end
end
