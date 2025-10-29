class Views::Projects::New < Views::App::Base
  def initialize(project:, organizations: [], current_project: nil)
    super(current_project: current_project)
    @project = project
    @organizations = organizations
  end

  def view_template
    div(class: "container mx-auto px-4 py-8") do
      # Dynamic Header
      h1(class: "text-3xl font-bold mb-6") do
        if @project.persisted?
          span { "Edit Project: " }
          span(class: "text-accent") { @project.name }
        else
          span { "New Project" }
        end
      end

      render Components::Projects::Form.new(project: @project, organizations: @organizations)
    end
  end
end

