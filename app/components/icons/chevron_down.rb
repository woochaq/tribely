class Components::Icons::ChevronDown < Components::Base
  DEFAULT_ATTRIBUTES = {
    viewBox: "0 0 20 20",
    fill: "currentColor",
    "aria-hidden": "true"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M5.22 8.22a.75.75 0 011.06 0L10 11.94l3.72-3.72a.75.75 0 111.06 1.06l-4.25 4.25a.75.75 0 01-1.06 0L5.22 9.28a.75.75 0 010-1.06z", clip_rule: "evenodd")
    end
  end
end
