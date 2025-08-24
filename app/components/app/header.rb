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
      div(class: "flex items-center justify-between p-4") do
        div(class: "flex items-center gap-x-4") do
          a(href: projects_path, class: "text-xl font-bold text-text") { "Tribely" }
          span(class: "h-6 w-px bg-crust", "aria-hidden": "true")

          div(class: "relative", data: { controller: "app--header-dropdown" }) do
            button(
              type: "button",
              class: "flex items-center gap-x-2 rounded-md px-3 py-1.5 text-text hover:bg-surface1",
              data: { action: "click->app--header-dropdown#toggle" }
            ) do
              span(class: "w-5 h-5 bg-success/50 rounded-sm")
              span(class: "font-semibold") { project_name }
              render Components::Icons::ChevronDown.new(class: "h-5 w-5 text-subtext0")
            end

            div(
              class: "hidden absolute left-0 z-10 mt-2 w-80 origin-top-left rounded-md bg-surface1 py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none",
              data: { "app--header-dropdown-target": "menu" }
            ) do
              a(href: projects_path, class: "block px-4 py-2 text-sm text-subtext1 hover:bg-surface2") { "Your Projects" }
              if view_context.current_user.projects.any?
                view_context.current_user.projects.each do |project|
                  a(
                    href: project_path(project),
                    class: class_names(
                      "block px-4 py-2 text-sm hover:bg-surface2",
                      (project == current_project) ? "text-success font-semibold" : "text-text"
                    )
                  ) { project.name }
                end
              else
                div(class: "px-4 py-2 text-sm text-subtext1") { "No projects yet." }
              end
              div(class: "border-t border-crust my-1")
              a(href: new_project_path, class: "block px-4 py-2 text-sm text-primary hover:bg-surface2") { "Create new project" }
            end
          end
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

        div(class: "flex items-center gap-x-4") do
          button(type: "button", class: "rounded-full p-2 text-subtext0 hover:text-text hover:bg-surface1") do
            span(class: "sr-only") { "View notifications" }
            render Components::Icons::Bell.new(class: "h-6 w-6")
          end

          render Components::Shared::HeaderAvatar.new(user: view_context.current_user)
        end
      end
    end
  end
end
