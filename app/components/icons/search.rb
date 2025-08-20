class Components::Icons::Search < Components::Base
  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    default_attributes = {
      viewBox: "0 0 20 20",
      fill: "currentColor",
      "aria-hidden": "true"
    }
    merged_attributes = default_attributes.merge(@attributes)

    svg(**merged_attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z", clip_rule: "evenodd")
    end
  end
end
