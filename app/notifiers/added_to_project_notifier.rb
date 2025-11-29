class AddedToProjectNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "ProjectMemberMailer"
    config.method = "added_to_project_email"
    config.params = -> { { project_user: params[:project_user] } }
  end

  required_param :project_user

  recipients do
    params[:project_user].user
  end
end
