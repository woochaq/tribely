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
    return true if user.organization_users.exists?(organization_id: record.organization_id, role: :owner)
    user.project_users.exists?(project_id: record.id, role: :owner)
  end

  def create?
    return true if record.organization_id.nil?
    user.organization_users.exists?(organization_id: record.organization_id, role: :owner)
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
    if user.project_users.exists?(project_id: record.id, role: :owner)
      [ :name, :prefix ]
    else
      []
    end
  end
end
