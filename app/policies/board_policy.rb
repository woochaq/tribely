class BoardPolicy < ApplicationPolicy
  def add_story?
    project = record.project
    return true if user.owns_organization?(project.organization)

    project_user = user.project_users.find_by(project_id: project.id)
    project_user&.owner? || project_user&.member?
  end
end
