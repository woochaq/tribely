class Components::Icons::XMark < Components::Base
  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    default_attributes = {
      class: "h-5 w-5",
      viewBox: "0 0 20 20",
      fill: "currentColor"
    }
    merged_attributes = default_attributes.merge(@attributes)

    svg(**merged_attributes) do |svg|
      svg.path(d: "M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z")
    end
  end
end
