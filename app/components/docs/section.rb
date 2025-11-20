class Components::Docs::Section < Components::Base
  def initialize(title, icon: nil)
    @title = title
    @icon = icon
  end

  def view_template(&block)
    div(class: "mb-12") do
      h2(class: "text-2xl font-bold text-text mb-6 flex items-center gap-2 pb-2 border-b border-gray-100") do
        plain @icon if @icon
        plain @title
      end
      div(class: "space-y-4 text-gray-600") do
        block.call
      end
    end
  end
end
