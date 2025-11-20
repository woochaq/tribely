class Components::Docs::Kbd < Components::Base
  def view_template(&block)
    kbd(class: "px-1.5 py-0.5 rounded border border-gray-200 bg-gray-50 text-gray-500 text-xs font-sans mx-1 shadow-[0px_1px_0px_0px_rgba(0,0,0,0.05)]") do
      block.call
    end
  end
end
