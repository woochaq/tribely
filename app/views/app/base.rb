# frozen_string_literal: true

class Views::App::Base < Views::Base
  attr_reader :current_project

  def initialize(current_project: nil, **)
    @current_project = current_project
    super(**)
  end
  include Components
  include Phlex::Rails::Helpers::Routes

  def around_template(&)
    layout = Components::AppLayout.new(title: page_title, current_project: @current_project)

    render(layout, &)
  end

  def page_title
    "Tribely APP"
  end
end
