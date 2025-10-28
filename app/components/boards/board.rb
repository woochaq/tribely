class Components::Boards::Board < Components::Base
  include Phlex::Rails::Helpers::LinkTo

  def initialize(board:)
    @board = board
  end

  def view_template
    div(class: "flex flex-col w-80 h-full") do
      div(class: "flex items-center justify-between px-3 py-2 flex-shrink-0") do
        h2(class: "text-md font-semibold text-text") do
          span { @board.kind.upcase }
        end
        link_to "+", new_project_story_path(@board.project, board_id: @board.id), data: { turbo_frame: "modal" }, class: "p-1 text-subtext0 hover:text-text"
      end

      render Components::Boards::StoriesList.new(board: @board)
    end
  end
end
