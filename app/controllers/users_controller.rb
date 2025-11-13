class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def mentions
    authorize @project, :show?
    @users = @project.users.includes([ :avatar_attachment ]).where("full_name LIKE ? OR email LIKE ?", "%#{params[:filter]}%", "%#{params[:filter]}%").limit(10)
    render Components::Users::PromptItems.new(users: @users)
  end

  private

  def set_project
    @project = policy_scope(Project).find(params[:project_id])
  end
end
