class Views::Projects::Show < Views::App::Base
  def initialize(project:, current_project: nil)
    super(current_project: current_project)
    @project = project
  end

  def page_title
    "#{@project.name} - Tribely"
  end

  def view_template
    render Components::Projects::Board.new(project: @project)
  end
end
