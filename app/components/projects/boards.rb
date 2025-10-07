class Components::Projects::Boards < Components::Base
  include Phlex::Rails::Helpers::TurboStreamFrom

  def initialize(project:)
    @project = project
  end

  def view_template
    # Board header (e.g., for filters or view options)
    div(class: "flex-shrink-0 mb-6 px-3") do
      h1(class: "text-2xl font-bold text-text") { @project.name }
    end

    # Main board container with horizontal scroll
    div(class: "flex-1 overflow-x-auto") do
      div(class: "inline-flex h-full") do
        @project.boards.includes(:project, stories: [ :user, :owner ]).each do |board|
          turbo_stream_from board
          render Components::Boards::Board.new(board: board)
        end
      end
    end
  end
end
