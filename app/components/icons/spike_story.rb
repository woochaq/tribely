# frozen_string_literal: true

class Components::Icons::SpikeStory < Components::Base
  def view_template
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 24 24",
      fill: "currentColor",
      class: "w-5 h-5 text-green-500"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d: "M11.25 2.25c.585 0 1.15.224 1.591.666l8.44 8.44a2.25 2.25 0 010 3.182l-8.44 8.44a2.25 2.25 0 01-3.182 0l-8.44-8.44a2.25 2.25 0 010-3.182l8.44-8.44A2.25 2.25 0 0111.25 2.25z",
        clip_rule: "evenodd"
      )
    end
  end
end
