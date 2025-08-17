class Components::Shared::FlashMessages < Components::Base
  include Phlex::Rails::Helpers::Flash
  include Phlex::Rails::Helpers::ClassNames

  def view_template
    div(class: "fixed top-0 right-0 z-50 p-4 w-full max-w-sm") do
      flash.each do |type, message|
        render_toast(type, message)
      end
    end
  end

  private

  def render_toast(type, message)
    base_classes = "flex items-start w-full p-4 mb-4 rounded-lg shadow-lg border border-l-4 transition-all duration-300 ease-in-out transform bg-surface1 border-crust"

    type_classes = case type.to_sym
    when :notice
      "border-l-blue text-blue"
    when :alert, :error
      "border-l-red text-red"
    when :success
      "border-l-green text-green"
    else
      "border-l-gray-500 text-text"
    end

    div(class: class_names(base_classes, type_classes),
        data: { controller: "app--toast", "app--toast-delay-value": 3000 }) do
      div(class: "flex-shrink-0 w-6 h-6 mr-4") do
        render_icon(type.to_sym)
      end

      div(class: "flex-1 font-semibold text-text") do
        p { message }
      end

      div(class: "ml-4 flex-shrink-0") do
        button(type: "button", class: "inline-flex rounded-md text-subtext0 hover:text-text transition-opacity", data: { action: "click->app--toast#close" }) do
          span(class: "sr-only") { "Close" }
          svg(class: "h-5 w-5", viewBox: "0 0 20 20", fill: "currentColor") do |svg|
            svg.path(d: "M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z")
          end
        end
      end
    end
  end

  def render_icon(type)
    icon_path = case type
    when :notice
      "M10 2a8 8 0 100 16 8 8 0 000-16zM9 12V9a1 1 0 012 0v3a1 1 0 01-2 0zm1 2.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z"
    when :alert, :error
      "M10 18a8 8 0 100-16 8 8 0 000 16zm.25-9.75a.75.75 0 00-1.5 0v4.5a.75.75 0 001.5 0v-4.5zM10 12a1 1 0 110 2 1 1 0 010-2z"
    when :success
      "M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
    else
      "M10 2a8 8 0 100 16 8 8 0 000-16zM9 12V9a1 1 0 012 0v3a1 1 0 01-2 0zm1 2.25a1.25 1.25 0 110-2.5 1.25 1.25 0 010 2.5z"
    end
    svg(class: "w-full h-full", viewBox: "0 0 20 20", fill: "currentColor") do |svg|
      svg.path(fill_rule: "evenodd", d: icon_path, clip_rule: "evenodd")
    end
  end
end
