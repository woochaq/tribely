class Components::Icons::ExclamationCircle < Components::Base
  DEFAULT_ATTRIBUTES = {
    class: "w-full h-full",
    viewBox: "0 0 20 20",
    fill: "currentColor"
  }.freeze

  def initialize(attributes = {})
    @attributes = attributes
  end

  def view_template
    svg(**DEFAULT_ATTRIBUTES, **@attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zm.25-9.75a.75.75 0 00-1.5 0v4.5a.75.75 0 001.5 0v-4.5zM10 12a1 1 0 110 2 1 1 0 010-2z", clip_rule: "evenodd")
    end
  end
end
