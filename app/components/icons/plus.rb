# frozen_string_literal: true

class Components::Icons::Plus < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "h-5 w-5",
    viewBox: "0 0 20 20",
    fill: "currentColor",
    "aria-hidden": "true"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z", clip_rule: "evenodd")
    end
  end
end
