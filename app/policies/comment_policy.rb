class CommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    project = record.story.project
    return true if user.owns_organization?(project.organization)

    project_user = user.project_users.find_by(project: project)
    project_user&.member? || project_user&.guest? || project_user&.owner?
  end

  def edit?
    update?
  end

  def update?
    return false unless record.user == user

    create?
  end

  def destroy?
    update?
  end

  def permitted_attributes
    [ :content ]
  end
end
