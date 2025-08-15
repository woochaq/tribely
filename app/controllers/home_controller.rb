class HomeController < ApplicationController
  def index
    render Views::Home::Index
  end
end
