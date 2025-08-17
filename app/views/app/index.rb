class Views::App::Index < Views::App::Base
  def page_title
    "Tribely APP My Board"
  end

  def view_template
    render Components::App::Board.new
  end
end
