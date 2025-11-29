class PagesController < ApplicationController
  skip_after_action :verify_authorized

  def privacy
    render Views::Pages::Privacy.new
  end

  def terms
    render Views::Pages::Terms.new
  end
end
