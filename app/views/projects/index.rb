class Views::Projects::Index < Views::App::Base
  def initialize(projects:)
    @projects = projects
  end

  def page_title
    "Projects - Tribely"
  end

  def view_template
    div(class: "flex-shrink-0 mb-6") do
      h1(class: "text-2xl font-bold text-text") { "Your projects" }
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
            span(class: "bg-mauve text-crust font-bold text-sm px-3 py-1 rounded-lg") { project.prefix }
            h3(class: "text-xl font-semibold text-text group-hover:text-mauve transition-colors") { project.name }
          end

          a(href: edit_project_path(project), class: "text-subtext0 hover:text-mauve p-2 rounded-md transition-colors", title: "Edit Project") do
            render Components::Icons::Edit.new(class: "w-5 h-5")
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
        a(href: "#", class: "btn-primary") { "Create Your First Project" }
      end
    end
  end
end
