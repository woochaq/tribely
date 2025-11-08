# frozen_string_literal: true

class Components::Shared::StatusBadge < Components::Base
  include Phlex::Rails::Helpers::T
  include Components::Shared::StoryStatusColors

  def initialize(status:)
    @status = status
  end

  def view_template
    return if @status.blank?

    span(class: "px-2 py-1 text-xs font-medium rounded-full #{badge_color_classes(@status)}") do
      t("activerecord.attributes.story.statuses.#{@status}")
    end
  end
end
