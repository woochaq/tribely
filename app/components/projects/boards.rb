class Components::Projects::Boards < Components::Base
  include Phlex::Rails::Helpers::TurboStreamFrom

  def initialize(project:)
    @project = project
  end

  def view_template
    turbo_stream_from @project
    div(class: "h-full flex flex-col") do
      # Board header
      div(class: "flex-shrink-0 mb-6 px-3") do
        h1(class: "text-2xl font-bold text-text") { @project.name }
      end

      # Container for boards that grows and scrolls horizontally
      div(class: "flex-1 flex gap-x-2 overflow-x-auto") do
        @project.boards.each do |board|
          render Components::Boards::Board.new(board: board)
        end
      end
    end
  end
end
