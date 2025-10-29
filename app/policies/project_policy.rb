class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.projects.exists?(id: record.id)
  end

  def new?
    true # TODO: check if user can add project to organization
  end

  def edit?
    user.project_users.exists?(project_id: record.id, role: :owner) # TODO: check in scope of organization maby
  end

  def create?
    true # TODO: check if user can create project for organization - maby by checking attribures....
  end

  def update?
    user.project_users.exists?(project_id: record.id, role: :owner) # TODO: check in scope of organization maby
  end

  def destroy?
    user.project_users.exists?(project_id: record.id, role: :owner) # TODO: check in scope of organization maby
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.projects
    end
  end
end
