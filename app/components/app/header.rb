class Components::App::Header < Components::Base
  include Phlex::Rails::Helpers::ClassNames
  attr_reader :current_project

  def initialize(current_project: nil)
    @current_project = current_project
  end

  def project_name
    current_project&.name || "Choose project..."
  end

  def view_template
    header(class: "bg-surface0 border-b border-crust flex-shrink-0") do
      div(class: "flex items-center p-4") do
        div(class: "flex items-center gap-x-4") do
          # Hamburger menu button for mobile
          button(
            type: "button",
            class: "p-2 text-subtext0 hover:text-text lg:hidden",
            data: { action: "click->mobile-navigation#toggle" }
          ) do
            span(class: "sr-only") { "Open sidebar" }
            render Icons::Bars3.new(class: "h-6 w-6")
          end
          div(class: "h-6 w-px bg-crust lg:hidden", "aria-hidden": "true")

          a(href: projects_path, class: "flex items-center gap-x-2") do
            img(src: view_context.image_path("logo.png"), alt: "Tribely Logo", class: "h-10 w-auto")
            span(class: "text-xl font-bold text-text") { "Tribely" }
          end
          span(class: "h-6 w-px bg-crust", "aria-hidden": "true")
        end

        div(class: "w-full max-w-md ml-8") do
          label(for: "search", class: "sr-only") { "Search" }
          div(class: "relative") do
            div(class: "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3") do
              render Components::Icons::Search.new(class: "h-5 w-5 text-subtext0")
            end
            input(id: "search", name: "search", class: "block w-full rounded-md border-0 bg-surface1 py-2 pl-10 pr-3 text-text placeholder:text-subtext0 focus:ring-2 focus:ring-inset focus:ring-primary", placeholder: "Search tasks...")
          end
        end
      end
    end
  end
end
