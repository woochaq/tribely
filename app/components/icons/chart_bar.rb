class Components::Icons::ChartBar < Components::Base
  def initialize(attributes = {})
    @attributes = attributes
    super()
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
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 3v18h18V3H3.75zM9 18.75v-6.75m6 6.75v-3.75m-3-6v-3.75")
    end
  end
end
