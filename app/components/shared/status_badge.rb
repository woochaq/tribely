# frozen_string_literal: true

class Components::Shared::StatusBadge < Components::Base
  include Phlex::Rails::Helpers::T

  def initialize(status:)
    @status = status
  end

  def view_template
    return if @status.blank?

    span(class: "px-2 py-1 text-xs font-medium rounded-full #{badge_color_classes}") do
      t("activerecord.attributes.story.statuses.#{@status}")
    end
  end

  private

  def badge_color_classes
    case @status
    when "todo"
      "bg-subtext0/20 text-subtext0"
    when "in_progress"
      "bg-info/20 text-info"
    when "in_review"
      "bg-accent/20 text-accent"
    when "done"
      "bg-success/20 text-success"
    when "archived"
      "bg-crust text-subtext0"
    else
      "bg-overlay1 text-text"
    end
  end
end
