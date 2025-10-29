# frozen_string_literal: true

class Components::Icons::Check < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "h-6 w-6 flex-none text-success",
    viewBox: "0 0 20 20",
    fill: "currentColor",
    "aria-hidden": "true"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.052-.143z", clip_rule: "evenodd")
    end
  end
end
