class Components::Footer < Components::Base
  def view_template
    footer do
      div(class: "container mx-auto px-6 py-8 text-center text-subtext0") do
        p { "© #{Time.now.year} ProjectFlow. All rights reserved." }
      end
    end
  end
end
