class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [ :index, :new, :create ]
  before_action :set_organizations, only: [ :new, :edit, :create ]

  def index
    authorize Project
    render Views::Projects::Index.new(projects: policy_scope(Project))
  end

  def show
    render Views::Projects::Show.new(project: @project, current_project: @project)
  end

  def new
    params[:project] ||= { organization_id: nil }
    @project = Project.new(permitted_attributes(Project))
    authorize @project
    render Views::Projects::New.new(project: @project, organizations: @organizations, current_project: nil)
  end

  def edit
    render Views::Projects::New.new(project: @project, organizations: @organizations, current_project: @project)
  end

  def create
    @project = Project.new(permitted_attributes(Project))
    @project.project_users.build(user: current_user, role: :owner)
    authorize @project
    if @project.save
      flash[:success] = "Project #{@project.name} created"
      redirect_to project_path(@project), status: :see_other
    else
      render Views::Projects::New.new(project: @project, organizations: @organizations, current_project: nil), status: :unprocessable_content
    end
  end

  def update
    if @project.update(permitted_attributes(@project))
      flash[:success] = "Project #{@project.name} updated"
      redirect_to projects_path, status: :see_other
    else
      render Views::Projects::New.new(project: @project, organizations: [], current_project: @project), status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project #{@project.name} destroyed"
    redirect_to projects_path
  end

  def settings
    authorize @project, :settings?
    render Views::Projects::Settings::Show.new(project: @project)
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:id])
    authorize @project
  end

  def set_organizations
    @organizations = current_user.organizations.includes(:organization_users).where(organization_users: { role: :owner })
  end
end
