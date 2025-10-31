class StoryPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    return true if user.owns_organization?(record.board.project.organization)
    project_user = user.project_users.find_by(project_id: record.board.project.id)
    project_user&.owner? || project_user&.member?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def move?
    create?
  end

  def permitted_attributes
    [ :board_id, :user_id, :owner_id, :title, :description, :status, :story_type ]
  end
end
