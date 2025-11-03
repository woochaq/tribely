class Views::Projects::New < Views::Projects::Base
  attr_reader :organizations

  def initialize(project:, organizations: [], **)
    @organizations = organizations
    super(project: project, **)
  end

  def view_template
    super do
      render Components::Projects::Form.new(project: @project, organizations: @organizations)
    end
  end

  def page_title
    if @project.persisted?
      "My Projects / #{@project.name} / Edit"
    else
      "My Projects / New Project"
    end
  end
end
