class Components::Icons::CheckCircle < Components::Base
  def initialize(attributes = {})
    @attributes = attributes
    super()
  end

  def view_template
    default_attributes = {
      class: "w-full h-full",
      viewBox: "0 0 20 20",
      fill: "currentColor"
    }
    merged_attributes = default_attributes.merge(@attributes)

    svg(**merged_attributes) do |svg|
      svg.path(fill_rule: "evenodd", d: "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z", clip_rule: "evenodd")
    end
  end
end
