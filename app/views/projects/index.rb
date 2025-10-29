class Views::Projects::Index < Views::App::Base
  include Phlex::Rails::Helpers::ButtonTo

  def initialize(projects:)
    @projects = projects
  end

  def page_title
    "Projects - Tribely"
  end

  def view_template
    div(class: "container mx-auto px-4 py-8") do
      div(class: "flex items-center justify-between gap-4 mb-6") do
        h1(class: "text-3xl font-bold text-text") { "My Projects" }
        a(href: new_project_path, class: "btn-primary") { "New Project" }
      end

      if @projects.any?
        div(class: "bg-mantle rounded-lg border border-crust shadow-lg") do
          ul(class: "divide-y divide-crust gap-y-2") do
            @projects.each do |project|
              render Components::Projects::ListItem.new(
                project: project,
                current_user: view_context.current_user
              )
            end
          end
        end
      else
        render_empty_state
      end
    end
  end

  private

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
