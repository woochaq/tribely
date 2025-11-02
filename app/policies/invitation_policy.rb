class InvitationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(organization_id: user.organization_ids)
    end
  end

  def create?
    user.owns_organization?(record.organization)
  end

  def destroy?
    user.owns_organization?(record.organization)
  end

  def resend?
    user.owns_organization?(record.organization)
  end

  def permitted_attributes
    [ :email, :role ]
  end
end
