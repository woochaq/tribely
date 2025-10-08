class Components::Icons::Cube < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "h-5 w-5",
    viewBox: "0 0 24 24",
    stroke_width: "1.5",
    stroke: "currentColor"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M16.5 0c2.485 0 4.5 2.015 4.5 4.5 0 1.24-.504 2.36-1.318 3.182c-.03.03-.06.06-.09.09L12 15.43l-7.092-7.658c-.03-.03-.06-.06-.09-.09C4.004 6.86 3.5 5.74 3.5 4.5C3.5 2.015 5.515 0 8 0h8.5zM4.5 18a1.5 1.5 0 00-1.5 1.5v3a1.5 1.5 0 001.5 1.5h15a1.5 1.5 0 001.5-1.5v-3a1.5 1.5 0 00-1.5-1.5h-15z")
    end
  end
end
