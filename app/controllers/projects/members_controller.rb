class Projects::MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_project_user, only: [ :edit, :update, :destroy ]

  def create
    @project_user = @project.project_users.build(project_user_params)
    authorize @project, :add_member?

    if @project_user.save
      redirect_to settings_project_path(@project), notice: "#{@project_user.user.name} has been added to the project."
    else
      # This will require a full re-render of the settings page to show errors
      redirect_to settings_project_path(@project), alert: @project_user.errors.full_messages.to_sentence
    end
  end

  def edit
    authorize @project, :edit_member?

    if @project_user.user == current_user
      redirect_to settings_project_path(@project), alert: "You cannot edit your own role."
      return
    end

    render Components::Projects::Members::Edit.new(project_user: @project_user)
  end

  def update
    authorize @project, :update_member?

    if @project_user.user == current_user
      redirect_to settings_project_path(@project), alert: "You cannot update your own role."
      return
    end

    if @project_user.update(project_user_params)
      render turbo_stream: turbo_stream.replace(@project_user, Components::Projects::UserListItem.new(project_user: @project_user))
    else
      render Components::Projects::Members::Edit.new(project_user: @project_user), status: :unprocessable_content
    end
  end

  def destroy
    authorize @project, :remove_member?

    if @project_user.user == current_user
      redirect_to settings_project_path(@project), alert: "You cannot remove yourself from the project."
      return
    end

    @project_user.destroy

    respond_to do |format|
      format.html { redirect_to settings_project_path(@project), notice: "#{@project_user.user.name} has been removed from the project." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@project_user) }
    end
  end

  private

  def set_project
    @project = policy_scope(Project).find_by!(slug: params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end

  def set_project_user
    @project_user = @project.project_users.find(params[:id])
  end

  def project_user_params
    params.require(:project_user).permit(:user_id, :role)
  end
end
