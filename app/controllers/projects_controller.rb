class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    render Views::Projects::Index.new(projects: current_user.projects)
  end

  def new
    @project = Project.new
    render Views::Projects::New.new(project: @project)
  end

  def edit
    @project = current_user.projects.find(params[:id])
    render Views::Projects::New.new(project: @project)
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      flash[:success] = "Project #{@project.name} create"
      redirect_to projects_path
    else
      render Components::Projects::Form.new(project: @project), status: :unprocessable_entity
    end
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update(project_params)
      flash[:success] = "Project #{@project.name} updated"
      redirect_to projects_path
    else
      render Views::Projects::New.new(project: @project), status: :unprocessable_entity
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    flash[:success] = "Project #{@project.name} destroyed"
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :prefix)
  end
end
