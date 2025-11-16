class DocumentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      member_project_ids = user.project_users.where.not(role: "guest").pluck(:project_id)
      owner_project_ids = Project.where(organization_id: user.organization_users.owner.select(:organization_id)).pluck(:id)
      all_accessible_project_ids = (member_project_ids | owner_project_ids)
      scope.where(project_id: all_accessible_project_ids)
    end
  end

  def index?
    true
  end

  def show?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def new?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def create?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def edit?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def update?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def destroy?
    user_is_project_member_but_not_guest_or_org_owner?
  end

  def permitted_attributes
    [ :title, :content ]
  end

  private

  def user_is_project_member_but_not_guest_or_org_owner?
    project = record.project
    is_project_member_but_not_guest = project.project_users.where(user: user).where.not(role: "guest").exists?
    is_org_owner = user.owns_organization?(project.organization)

    is_project_member_but_not_guest || is_org_owner
  end
end
