class Components::Docs::Badge < Components::Base
  def initialize(color: :gray)
    @color = color
  end

  def view_template(&block)
    colors = case @color
    when :blue then "bg-blue-100 text-blue-700"
    when :green then "bg-green-100 text-green-700"
    when :red then "bg-red-100 text-red-700"
    when :purple then "bg-purple-100 text-purple-700"
    when :yellow then "bg-yellow-100 text-yellow-800"
    else "bg-gray-100 text-gray-600"
    end

    span(class: "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium #{colors} mr-1") do
      block.call
    end
  end
end
