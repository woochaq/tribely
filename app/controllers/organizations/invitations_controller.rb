class Organizations::InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_invitation, only: [ :destroy, :resend ]

  def create
    @invitation = @organization.invitations.build(permitted_attributes(Invitation))
    @invitation.sender = current_user
    authorize @invitation

    if @invitation.save
      InvitationMailer.invitation_email(@invitation).deliver_later
      redirect_to organization_members_path(@organization), notice: "Invitation sent successfully."
    else
      redirect_to organization_members_path(@organization), alert: @invitation.errors.full_messages.to_sentence
    end
  end

  def destroy
    authorize @invitation
    if @invitation.pending?
      @invitation.destroy
      redirect_to organization_members_path(@organization), notice: "Invitation cancelled successfully."
    else
      redirect_to organization_members_path(@organization), alert: "Only pending invitations can be cancelled."
    end
  end

  def resend
    authorize @invitation
    if @invitation.pending?
      InvitationMailer.invitation_email(@invitation).deliver_later
      redirect_to organization_members_path(@organization), notice: "Invitation re-sent successfully."
    else
      redirect_to organization_members_path(@organization), alert: "Only pending invitations can be re-sent."
    end
  end

  private

  def set_organization
    @organization = policy_scope(Organization).find(params[:organization_id])
  end

  def set_invitation
    @invitation = @organization.invitations.find(params[:id])
  end
end
