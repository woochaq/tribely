class Components::Stories::Story < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  def initialize(story:)
    @story = story
  end

  def view_template
    div(class: "bg-surface0 border border-crust rounded-lg p-3 shadow-sm hover:bg-surface1 cursor-pointer") do
      link_to project_board_story_path(@story.board.project, @story.board, @story) do
        p(class: "font-semibold text-text") { @story.title }
        div(class: "flex items-center justify-between mt-4") do
          span(class: "text-xs text-subtext0") { "#{@story.board.project.prefix}-#{@story.number}" }
          render Components::Shared::Avatar(user: @story.user, size: "w-6 h-6", bg: "bg-info/50", font_size: "text-xs")
        end
      end
    end
  end
end
