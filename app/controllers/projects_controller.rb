class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create ]

  def index
    authorize Project
    render Views::Projects::Index.new(projects: policy_scope(Project))
  end

  def show
    render Views::Projects::Show.new(project: @project, current_project: @project)
  end

  def new
    @project = Project.new
    authorize @project
    render Views::Projects::New.new(project: @project, current_project: nil)
  end

  def edit
    render Views::Projects::New.new(project: @project, current_project: @project)
  end

  def create
    @project = Project.new(project_params)
    @project.users << current_user
    authorize @project
    if @project.save
      flash[:success] = "Project #{@project.name} create"
      redirect_to projects_path(@project), status: :see_other
    else
      render Views::Projects::New.new(project: @project, current_project: nil), status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = "Project #{@project.name} updated"
      redirect_to projects_path, status: :see_other
    else
      render Views::Projects::New.new(project: @project, current_project: @project), status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project #{@project.name} destroyed"
    redirect_to projects_path
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:project).permit(:name, :prefix)
  end
end
