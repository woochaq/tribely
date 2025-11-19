class WebhookPolicy < ApplicationPolicy
  def index?
    user_is_owner?
  end

  def create?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  private

  def user_is_owner?
    project = record.project
    return false unless project

    user.owns_project?(project) || (project.organization && user.owns_organization?(project.organization))
  end
end
