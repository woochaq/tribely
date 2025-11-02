class Organizations::MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_organization_user, only: [ :edit, :update, :destroy ]

  def edit
    authorize @organization, :edit_member?

    if @organization_user.user == current_user
      redirect_to members_organization_path(@organization), alert: "You cannot edit your own role."
      return
    end

    render Components::Organizations::Members::Edit.new(organization_user: @organization_user)
  end

  def update
    authorize @organization, :update_member?

    if @organization_user.user == current_user
      redirect_to members_organization_path(@organization), alert: "You cannot update your own role."
      return
    end

    @organization_user.role = params.require(:organization_user).fetch(:role, @organization_user.role)
    if @organization_user.save
      render turbo_stream: turbo_stream.replace(@organization_user, Components::Organizations::UserListItem.new(organization_user: @organization_user))
    else
      render Components::Organizations::Members::Edit.new(organization_user: @organization_user), status: :unprocessable_content
    end
  end

  def destroy
    authorize @organization, :destroy_member?

    if @organization_user.user == current_user
      redirect_to members_organization_path(@organization), alert: "You cannot remove yourself from the organization."
      return
    end

    @organization_user.destroy

    redirect_to members_organization_path(@organization), notice: "#{@organization_user.user.name} has been removed from the organization."
  end

  private

  def set_organization
    @organization = policy_scope(Organization).find(params[:organization_id])
  end

  def set_organization_user
    @organization_user = @organization.organization_users.find(params[:id])
  end
end
