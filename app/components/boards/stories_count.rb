class Components::Boards::StoriesCount < Components::Base
  include Phlex::Rails::Helpers::DOMID

  def initialize(board:)
    @board = board
  end

  def view_template
    span(id: dom_id(@board, :stories_count), class: "ml-2 text-sm font-normal text-subtext0") { @board.stories.count }
  end
end
