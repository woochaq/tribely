class Components::Boards::Board < Components::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMID

  def initialize(board:)
    @board = board
  end

  def view_template
    div(class: "flex flex-col w-5/6 lg:w-80 h-full flex-shrink-0") do
      div(class: "flex items-center justify-between px-3 py-2 flex-shrink-0") do
        h2(class: "text-md font-semibold text-text") do
          span { @board.kind.upcase }
        end
        if policy(@board).add_story?
          link_to "+", new_project_story_path(@board.project, board_id: @board.id), data: { turbo_frame: "modal" }, class: "p-1 text-subtext0 hover:text-text"
        end
      end

      div(
        id: dom_id(@board),
        class: "flex-1 overflow-y-auto p-1 space-y-1",
        data: (policy(Story.new(board: @board)).move? ? { controller: "boards", "boards-group-value": "stories", "board-id": @board.id, "boards-move-url-value": move_project_story_path(@board.project, ":id") } : {})
      ) do
        render Components::Boards::StoriesList.new(board: @board)
      end
    end
  end
end
