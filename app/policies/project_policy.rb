class ProjectPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.all_projects
    end
  end

  def index?
    true
  end

  def show?
    user.projects.exists?(id: record.id)
  end

  def new?
    true
  end

  def edit?
    return true if user.owns_organization?(record.organization)
    user.owns_project?(record)
  end

  def create?
    return true if record.organization_id.nil?
    user.owns_organization?(record.organization)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def permitted_attributes_for_create
    [ :name, :prefix, :organization_id ]
  end

  def permitted_attributes_for_update
    if user.owns_project?(record)
      [ :name, :prefix ]
    else
      []
    end
  end
end
