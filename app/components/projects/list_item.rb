class Components::Projects::ListItem < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ButtonTo
  include Pundit::Authorization

  attr_reader :project, :current_user

  def initialize(project:, current_user:)
    @project = project
    @current_user = current_user
  end

  def view_template
    li(class: "p-4 flex items-center justify-between hover:bg-surface0") do
      link_to(project_path(project), class: "flex-grow flex items-center gap-x-4") do
        div(class: "w-10 h-10 bg-surface1 rounded-lg flex-shrink-0 flex items-center justify-center font-bold text-sm") do
          project.prefix
        end

        div do
          span(class: "font-semibold text-text") { project.name }
        end
      end

      # Actions on the right side
      div(class: "flex items-center gap-x-2 flex-shrink-0") do
        render_role_badge

        if policy(project).show?
          link_to "Details", settings_project_path(project), class: "btn-secondary"
        end

        if policy(project).destroy?
          button_to(
            project_path(project),
            method: :delete,
            form: { data: { turbo_confirm: "Are you sure you want to delete this project? This action cannot be undone." } },
            class: "p-2 text-subtext0 hover:text-danger transition-colors"
          ) do
            render Components::Icons::Delete.new(class: "w-5 h-5 cursor-pointer")
          end
        end
      end
    end
  end

  private

  def user_role
    @user_role ||= project.project_users.find_by(user_id: current_user.id)&.role
  end

  def render_role_badge
    return unless user_role

    badge_colors = {
      "owner" => "bg-accent text-crust",
      "member" => "bg-primary text-crust"
    }
    color_classes = badge_colors[user_role] || "bg-surface2 text-text"

    span(class: "px-2 py-1 text-xs font-bold rounded-full #{color_classes}") do
      user_role.capitalize
    end
  end
end
