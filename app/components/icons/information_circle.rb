class Components::Icons::InformationCircle < Components::Base
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
      svg.path(fill_rule: "evenodd", d: "M10 2a8 8 0 100 16 8 8 0 000-16zM9 12V9a1 1 0 012 0v3a1 1 0 01-2 0zm1 2.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z", clip_rule: "evenodd")
    end
  end
end
