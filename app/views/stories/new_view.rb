class Views::Stories::NewView < Views::App::Base
  def initialize(story:, board: @board, current_project: nil)
    @story = story
    @board = board
    super(current_project: current_project)
  end

  def view_template
    div(class: "max-w-2xl mx-auto") do
      h1(class: "font-bold text-4xl mb-8") { "New Story" }

      div(class: "bg-mantle p-8 rounded-2xl border border-crust shadow-lg shadow-crust/20") do
        render Views::Stories::FormView.new(story: @story, board: @board, current_project: @current_project)
      end
    end
  end
end

