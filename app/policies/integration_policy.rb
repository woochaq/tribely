class IntegrationPolicy < ApplicationPolicy
  def index?
    user_is_owner?
  end

  def create?
    user_is_owner?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope.joins(project: :organization).where("projects.id IN (?) OR organizations.id IN (?)", user.project_ids, user.organization_ids).distinct
    end
  end

  private

  def user_is_owner?
    project = record.project
    return false unless project

    user.owns_project?(project) || (project.organization && user.owns_organization?(project.organization))
  end
end
