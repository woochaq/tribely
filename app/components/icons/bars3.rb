# frozen_string_literal: true

class Components::Icons::Bars3 < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "h-5 w-5",
    fill: "none",
    viewBox: "0 0 24 24",
    stroke_width: "1.5",
    stroke: "currentColor"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5")
    end
  end
end
