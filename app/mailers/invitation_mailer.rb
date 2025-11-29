class InvitationMailer < ApplicationMailer
  def invitation_email
    @invitation = params[:invitation]
    @organization = @invitation.organization
    @sender = @invitation.sender

    mail(to: @invitation.email, subject: "You have been invited to join #{@organization.name}")
  end
end
