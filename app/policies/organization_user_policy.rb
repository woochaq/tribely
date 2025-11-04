class OrganizationUserPolicy < ApplicationPolicy
  def edit?
    user.owns_organization?(record.organization) && record.user != user
  end

  def update?
    user.owns_organization?(record.organization) && record.user != user
  end

  def destroy?
    user.owns_organization?(record.organization) && record.user != user
  end
end
