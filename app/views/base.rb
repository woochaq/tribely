# frozen_string_literal: true

class Views::Base < Phlex::HTML
  include Components
  include Phlex::Rails::Helpers::Routes

  def around_template(&)
    layout = Components::Layout.new(title: page_title)

    render(layout, &)
  end

  def page_title
    "Tribely"
  end

  def current_user
    view_context.current_user
  end
end
