# frozen_string_literal: true

class Components::Icons::BugStory < Components::Base
  def view_template
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 24 24",
      fill: "currentColor",
      class: "w-5 h-5 text-red-500"
    ) do |s|
      s.path(d: "M14,12H10A2,2 0 0,0 8,14V16H6V14A4,4 0 0,1 10,10H14A4,4 0 0,1 18,14V16H16V14A2,2 0 0,0 14,12M20,8H17V6H15V8H9V6H7V8H4V10H20V8M4,18H6V20H8V18H16V20H18V18H20V16H4V18Z")
    end
  end
end
