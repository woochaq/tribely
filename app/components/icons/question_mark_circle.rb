class Components::Icons::QuestionMarkCircle < Components::Base
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
      svg.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z")
    end
  end
end
