# frozen_string_literal: true

module Components::Shared::StoryStatusColors
  def badge_color_classes(status)
    case status
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

  def button_color_classes(status)
    case status
    when "todo", "in_progress", "done"
      "btn-secondary"
    when "in_review" # Dla "Accept"
      "btn-success"
    else
      "btn-secondary"
    end
  end
end
