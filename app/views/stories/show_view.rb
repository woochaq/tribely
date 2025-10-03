class Views::Stories::ShowView < Views::App::Base
  include Phlex::Rails::Helpers::LinkTo
  def initialize(story:, board:, current_project: nil)
    @story = story
    @project = current_project
    @board = board
    super(current_project: current_project)
  end

  def view_template
    div(class: "w-full") do
      div(class: "flex justify-between items-center mb-5") do
        h1(class: "font-bold text-4xl") { "Story" }
        div(class: "flex space-x-2") do
          link_to "Edit", edit_project_board_story_path(@project, @board, @story), class: "btn-secondary"
          link_to "Back", project_path(@project), class: "btn-secondary"
        end
      end

      render Views::Stories::StoryView.new(story: @story)
    end
  end
end
