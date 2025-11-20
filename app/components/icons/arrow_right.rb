class Components::Icons::ArrowRight < Components::Base
  def initialize(class: "w-6 h-6")
    @class = binding.local_variable_get(:class)
  end

  def view_template
    svg(xmlns: "http://www.w3.org/2000/svg", fill: "none", viewbox: "0 0 24 24", stroke_width: "2", stroke: "currentColor", class: @class) do |s|
      s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3")
    end
  end
end
