class Components::Boards::Board < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboStreamFrom

  def initialize(board:)
    @board = board
  end

  def view_template
    div(class: "flex flex-col w-80 h-full") do
      div(class: "flex items-center justify-between px-3 py-2 flex-shrink-0") do
        h2(class: "text-md font-semibold text-text") do
          span { @board.name }
          span(class: "ml-2 text-sm font-normal text-subtext0") { @board.stories.count }
        end
        link_to "...", new_project_board_story_path(@board.project, @board), data: { turbo_frame: "modal" }, class: "p-1 text-subtext0 hover:text-text"
      end

      turbo_stream_from @board
      div(id: dom_id(@board), class: "flex-1 overflow-y-auto p-1 space-y-1") do
        @board.stories.each do |story|
          render Components::Stories::Story.new(story: story)
        end
      end
    end
  end
end
