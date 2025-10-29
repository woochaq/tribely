class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.organizations
    end
  end

  def index?
    true
  end

  def show?
    user.organizations.exists?(id: record.id)
  end

  def edit?
    user.organization_users.exists?(organization_id: record.id, role: :owner)
  end

  def update?
    edit?
  end

  def permitted_attributes
    if user.organization_users.exists?(organization_id: record.id, role: :owner)
      [ :name ]
    else
      []
    end
  end
end
