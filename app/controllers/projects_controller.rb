class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render Views::Projects::Index.new(projects: current_user.projects)
  end
end
