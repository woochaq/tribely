class Components::Boards::StoriesList < Components::Base
  include Phlex::Rails::Helpers::DOMID

  def initialize(board:)
    @board = board
  end

  def view_template
    div(
      id: dom_id(@board),
      class: "flex-1 overflow-y-auto p-1 space-y-1",
      data: { controller: "boards", "boards-group-value": "stories", "board-id": @board.id, "boards-move-url-value": move_project_story_path(@board.project, ":id") }
    ) do
      @board.stories.includes(:user, :owner, board: [ :project ]).sort_by(&:position).each do |story|
        render Components::Stories::Story.new(story: story)
      end
    end
  end
end
