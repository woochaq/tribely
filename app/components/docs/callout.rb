class Components::Docs::Callout < Components::Base
  def initialize(icon: nil, color: :gray, title: nil)
    @icon = icon
    @color = color
    @title = title
  end

  def view_template(&block)
    bg_class = case @color
    when :blue then "bg-blue-50 border-blue-100 text-blue-900"
    when :red then "bg-red-50 border-red-100 text-red-900"
    when :yellow then "bg-yellow-50 border-yellow-100 text-yellow-900"
    when :green then "bg-green-50 border-green-100 text-green-900"
    else "bg-gray-50 border-gray-200 text-gray-900"
    end

    div(class: "p-4 rounded-lg border #{bg_class} flex items-start gap-3 mb-6") do
      div(class: "text-xl") { @icon } if @icon
      div(class: "flex-1") do
        h4(class: "font-semibold mb-1") { @title } if @title
        div(class: "text-sm leading-relaxed opacity-90") { block.call }
      end
    end
  end
end
