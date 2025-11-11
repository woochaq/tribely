# frozen_string_literal: true

class Components::App::Sidebar::ProjectSwitcher < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ClassNames

  attr_reader :current_project, :projects

  def initialize(current_project:, projects:)
    @current_project = current_project
    @projects = projects
  end

  def view_template
    div(class: "relative p-4 border-b border-crust", data: { controller: "app--header-dropdown" }) do
      button(
        type: "button",
        class: "flex items-center justify-between w-full rounded-md px-3 py-2 text-text hover:bg-surface1 transition-colors",
        data: { action: "click->app--header-dropdown#toggle" }
      ) do
        div(class: "flex items-center gap-x-2 min-w-0") do
          span(class: "font-semibold truncate") { current_project.try(:name) || "Choose..." }
        end
        render Components::Icons::ChevronDown.new(class: "h-5 w-5 text-subtext0")
      end

      div(
        class: "hidden absolute left-5 z-10 mt-2 w-full origin-top-left rounded-md bg-surface1 py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none",
        data: { "app--header-dropdown-target": "menu" }
      ) do
        if projects.any?
          a(href: projects_path, class: "block px-4 py-2 text-sm text-subtext1 hover:bg-surface2") { "Your Projects" }
          div(class: "border-t border-crust my-1")
          projects.each do |project|
            a(
              href: project_path(project),
              class: class_names(
                "block px-4 py-2 text-sm hover:bg-surface2 truncate",
                (project == current_project) ? "text-accent font-semibold" : "text-text"
              )
            ) { project.name }
          end
        else
          div(class: "px-4 py-2 text-sm text-subtext1") { "No projects yet." }
        end
        div(class: "border-t border-crust my-1")
        a(href: new_project_path, class: "block px-4 py-2 text-sm text-primary hover:bg-surface2") { "+ Create new project" }
      end
    end
  end
end
