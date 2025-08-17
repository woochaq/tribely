# frozen_string_literal: true

class Views::App::Base < Views::Base
  include Components
  include Phlex::Rails::Helpers::Routes

  def around_template(&)
    layout = Components::AppLayout.new(title: page_title)

    render(layout, &)
  end

  def page_title
    "Tribely APP"
  end
end
