class Organizations::MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_organization_user, only: [ :edit, :update, :destroy ]

  def edit
    authorize @organization_user

    render Components::Organizations::Members::Edit.new(organization_user: @organization_user)
  end

  def update
    authorize @organization_user

    @organization_user.role = params.require(:organization_user).fetch(:role, @organization_user.role)
    if @organization_user.save
      render turbo_stream: turbo_stream.replace(@organization_user, Components::Organizations::UserListItem.new(organization_user: @organization_user))
    else
      render Components::Organizations::Members::Edit.new(organization_user: @organization_user), status: :unprocessable_content
    end
  end

  def destroy
    authorize @organization_user

    @organization_user.destroy

    respond_to do |format|
      format.html { redirect_to members_organization_path(@organization), notice: "#{@organization_user.user.name} has been removed from the organization." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@organization_user) }
    end
  end

  private

  def set_organization
    @organization = policy_scope(Organization).find(params[:organization_id])
  end

  def set_organization_user
    @organization_user = @organization.organization_users.find(params[:id])
  end
end
