class AppController < ApplicationController
  before_action :authenticate_user!

  def index
    render Views::App::Index
  end
end
