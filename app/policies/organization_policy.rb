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

  def members?
    show?
  end

  def edit?
    user.owns_organization?(record)
  end

  def update?
    edit?
  end

  def permitted_attributes
    if user.owns_organization?(record)
      [ :name ]
    else
      []
    end
  end
end
