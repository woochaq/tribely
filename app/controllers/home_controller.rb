class HomeController < ApplicationController
  def index
    authorize :home
    render Views::Home::Index
  end
end
