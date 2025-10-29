class Components::Icons::Organization < Phlex::HTML
  DEFAULT_ATTRIBUTES = {
      xmlns: "http://www.w3.org/2000/svg",
      fill: "none",
      viewBox: "0 0 24 24",
      stroke_width: "1.5",
      stroke: "currentColor",
      class: "w-6 h-6"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end
  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |s| s.path(
        stroke_linecap: "round",
        stroke_linejoin: "round",
        d: "M3.75 21h16.5M4.5 3h15M5.25 3v18m13.5-18v18M9 6.75h6M9 11.25h6M9 15.75h6"
      )
    end
  end
end
