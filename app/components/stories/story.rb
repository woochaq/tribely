class Components::Stories::Story < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMID

  def initialize(story:)
    @story = story
  end

  def view_template
    link_to(
      project_board_story_path(@story.board.project, @story.board, @story),
      data: { turbo_frame: "modal", "story-id": @story.id },
      id: dom_id(@story),
      class: "block bg-surface0 border border-crust rounded-lg p-3 shadow-sm hover:bg-surface1 cursor-pointer"
    ) do
      p(class: "font-semibold text-text") { @story.title }
      div(class: "flex items-center justify-between mt-4") do
        span(class: "text-xs text-subtext0") { "#{@story.board.project.prefix}-#{@story.number}" }
        render Components::Shared::Avatar(user: @story.user, size: "w-6 h-6", bg: "bg-info/50", font_size: "text-xs")
      end
    end
  end
end
