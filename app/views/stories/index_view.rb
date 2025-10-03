class Views::Stories::IndexView < Views::App::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  def initialize(stories:, board:, current_project: nil)
    @stories = stories
    @board = board
    @project = current_project
    super(current_project: current_project)
  end

  def view_template
    div(class: "w-full") do
      div(class: "flex justify-between items-center") do
        h1(class: "font-bold text-4xl") { "Stories" }
        link_to "New story", new_project_board_story_path(@current_project, @board), class: "btn-primary"
      end

      div(id: "stories", class: "min-w-full divide-y divide-surface0 space-y-5") do
        if @stories.any?
          @stories.each do |story|
            div(class: "flex flex-col sm:flex-row justify-between items-center pb-5 sm:pb-0") do
              render Views::Stories::StoryView.new(story: story)
              div(class: "w-full sm:w-auto flex flex-col sm:flex-row space-x-2 space-y-2") do
                link_to "Show", project_board_story_path(@project, @board, story), class: "btn-secondary"
                link_to "Edit", edit_project_board_story_path(@project, @board, story), class: "btn-secondary"
                button_to "Destroy", project_board_story_path(@project, @board, story), method: :delete, class: "btn-warn", data: { turbo_confirm: "Are you sure?" }
              end
            end
          end
        else
          p(class: "text-center my-10") { "No stories found." }
        end
      end
    end
  end
end

