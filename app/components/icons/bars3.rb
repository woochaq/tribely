class Components::Icons::Bars3 < Components::Base
  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    default_attributes = {
      class: "h-5 w-5",
      fill: "none",
      viewBox: "0 0 24 24",
      stroke_width: "1.5",
      stroke: "currentColor"
    }
    merged_attributes = default_attributes.merge(@attributes)

    svg(**merged_attributes) do |svg|
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5")
    end
  end
end
