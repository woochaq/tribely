class ProjectMemberMailer < ApplicationMailer
  def added_to_project_email(project_user)
    @project_user = project_user
    @project = project_user.project
    @added_by = project_user.added_by

    mail(to: @project_user.user.email, subject: "You have been added to the project: #{@project.name}")
  end
end
