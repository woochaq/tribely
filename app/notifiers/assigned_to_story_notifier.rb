class AssignedToStoryNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "NotificationMailer"
    config.method = "user_assigned_to_story_email"
    config.params = -> { { story: params[:story], assigner: params[:assigner], assigned_user: params[:assigned_user] } }
  end

  required_params :story, :assigner, :assigned_user

  recipients do
    params[:assigned_user]
  end
end
