# frozen_string_literal: true

class Components::Icons::Logout < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "h-5 w-5 mr-2",
    viewBox: "0 0 20 20",
    fill: "none",
    viewbox: "0 0 24 24",
    stroke_width: "1.5",
    stroke: "currentColor"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(
        stroke_linecap: "round",
        stroke_linejoin: "round",
        d:
          "M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15m3 0l3-3m0 0l-3-3m3 3H9"
      )
    end
  end
end
