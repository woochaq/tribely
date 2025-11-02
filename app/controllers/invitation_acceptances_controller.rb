class InvitationAcceptancesController < ApplicationController
  before_action :set_invitation

  def new
    authorize :invitation_acceptance
    if @invitation.accepted? || @invitation.expired?
      redirect_to root_path, alert: "This invitation has already been accepted or has expired."
      return
    end


    if current_user
      if current_user.email == @invitation.email
        accept_invitation_for_existing_user(current_user)
      else
        redirect_to root_path, alert: "This invitation is for a different email address. Please log out or use the correct account."
      end
    else
      user = User.find_by(email: @invitation.email)
      if user
        session[:invitation_token] = @invitation.token
        redirect_to new_user_session_path(email: @invitation.email), alert: "Please log in to accept the invitation."
      else
        session[:invitation_token] = @invitation.token
        redirect_to new_user_registration_path(user: { email: @invitation.email })
      end
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Invalid or expired invitation token."
  end

  def accept_invitation_for_existing_user(user)
    if AcceptInvitation.call(invitation: @invitation, user: user)
      sign_in(user)
      redirect_to organization_path(@invitation.organization), notice: "Welcome to #{@invitation.organization.name}!"
    else
      redirect_to root_path, alert: "There was an error accepting the invitation. Please try again."
    end
  end
end
