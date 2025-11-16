# frozen_string_literal: true

class Components::Icons::Calendar < Components::Base
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
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0h18M-7.5 12h15")
    end
  end
end
