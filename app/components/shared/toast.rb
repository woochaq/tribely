class Components::Shared::Toast < Components::Base
  include Phlex::Rails::Helpers::ClassNames

  def initialize(type:, message:)
    @type = type
    @message = message
  end

  def view_template
    base_classes = "flex items-start w-full p-4 mb-4 rounded-lg shadow-lg border border-l-4 transition-all duration-300 ease-in-out transform bg-surface1 border-crust"

    type_classes = case @type.to_sym
    when :notice
      "border-l-info text-info"
    when :alert, :error
      "border-l-danger text-danger"
    when :success
      "border-l-success text-success"
    else
      "border-l-surface2 text-text"
    end

    div(class: class_names(base_classes, type_classes),
        data: { controller: "app--toast", "app--toast-delay-value": 3000 }) do
      div(class: "flex-shrink-0 w-6 h-6 mr-4") do
        render_icon(@type.to_sym)
      end

      div(class: "flex-1 font-semibold text-text") do
        p { @message }
      end

      div(class: "ml-4 flex-shrink-0") do
        button(type: "button", class: "inline-flex rounded-md text-subtext0 hover:text-text transition-opacity", data: { action: "click->app--toast#close" }) do
          span(class: "sr-only") { "Close" }
          render Components::Icons::XMark.new(class: "h-5 w-5")
        end
      end
    end
  end

  private

  def render_icon(type)
    case type
    when :notice
      render Components::Icons::InformationCircle.new(class: "w-full h-full")
    when :alert, :error
      render Components::Icons::ExclamationCircle.new(class: "w-full h-full")
    when :success
      render Components::Icons::CheckCircle.new(class: "w-full h-full")
    else
      render Components::Icons::InformationCircle.new(class: "w-full h-full")
    end
  end
end
