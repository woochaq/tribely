class InvitationNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "InvitationMailer"
    config.method = "invitation_email"
    config.params = -> { { invitation: params[:invitation] } }
  end

  required_param :invitation

  recipients do
    params[:invitation]
  end
end
