class Organizations::MembersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    organization = policy_scope(Organization).find(params[:organization_id])
    organization_user = organization.organization_users.find(params[:id])

    authorize organization, :destroy_member?

    if organization_user.user == current_user
      redirect_to members_organization_path(organization), alert: "You cannot remove yourself from the organization."
      return
    end

    organization_user.destroy

    redirect_to members_organization_path(organization), notice: "#{organization_user.user.name} has been removed from the organization."
  end
end
