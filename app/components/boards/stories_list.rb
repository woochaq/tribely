class Components::Boards::StoriesList < Components::Base
  def initialize(board:)
    @board = board
  end

  def view_template
    @board.stories.includes(:user).order(position: :asc).each do |story|
      render Components::Stories::Story.new(story: story)
    end
  end
end
