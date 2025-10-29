class Views::Projects::Index < Views::App::Base
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(projects:)
    @projects = projects
  end

  def page_title
    "Projects - Tribely"
  end

  def view_template
    div(class: "flex items-center justify-between gap-4 mb-8") do
      h1(class: "text-3xl font-bold text-text") { "Your Projects" }
      a(href: new_project_path, class: "btn-primary") { "New Project" }
    end

    if @projects.any?
      render_projects_list
    else
      render_empty_state
    end
  end

  private

  def render_projects_list
    div(class: "space-y-4") do
      @projects.each do |project|
        div(class: "flex items-center justify-between bg-mantle p-4 rounded-2xl border border-crust shadow-lg shadow-crust/20") do
          a(href: project_path(project), class: "flex flex-grow items-center gap-4 group") do
            span(class: "bg-primary text-crust font-bold text-sm px-3 py-1 rounded-lg") { project.prefix }
            h3(class: "text-xl font-semibold text-text group-hover:text-primary transition-colors") { project.name }
          end

          if view_context.policy(project).update?
            div(class: "flex items-center gap-2") do
              a(href: edit_project_path(project), class: "text-subtext0 hover:text-primary p-2 rounded-md transition-colors", title: "Edit Project") do
                render Components::Icons::Edit.new(class: "w-5 h-5")
              end
            end
            button_to(project_path(project),
              method: :delete,
              form: { data: { turbo_confirm: "Are you sure you want to delete this project? This action cannot be undone." } },
              class: "text-subtext0 p-2 rounded-md transition-colors cursor-pointer hover:text-primary",
              title: "Delete Project"
            ) do
              render Components::Icons::Delete.new(class: "w-5 h-5")
            end
          end
        end
      end
    end
  end

  def render_empty_state
    div(class: "bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20 text-center") do
      h3(class: "text-xl font-semibold text-text") { "No projects yet!" }
      p(class: "text-subtext0 mt-2") { "It looks like you haven't created any projects." }

      div(class: "mt-6") do
        a(href: new_project_path, class: "btn-primary") { "Create Your First Project" }
      end
    end
  end
end
