class ProjectUserPolicy < ApplicationPolicy
  def create?
    return true if user.owns_organization?(record.project.organization)
    user.owns_project?(record.project)
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [ :user_id ]
  end
end
