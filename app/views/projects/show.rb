class Views::Projects::Show < Views::App::Base
  def initialize(project:, current_project: nil, story_to_show: nil)
    super(current_project: current_project)
    @project = project
    @story_to_show = story_to_show
  end

  def page_title
    "#{@project.name} - Tribely"
  end

  def view_template
    render Components::Projects::Boards.new(project: @project)
    if @story_to_show
      render Components::Stories::Form.new(
        story: @story_to_show,
        current_project: @project
      )
    end
  end
end
