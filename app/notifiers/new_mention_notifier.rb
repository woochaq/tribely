class NewMentionNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "NotificationMailer"
    config.method = "user_mentioned"
    config.params = -> { { model_record: params[:model_record], mentioner: params[:mentioner] } }
  end

  required_params :mentioner, :model_record, :recipient

  recipients do
    params[:recipient]
  end
end
