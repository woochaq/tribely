class Components::Projects::UserListItem < Components::Base
  include Pundit::Authorization
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::LinkTo

  attr_reader :project_user

  def initialize(project_user:)
    @project_user = project_user
  end

  def view_template
    turbo_frame_tag project_user do
      li(class: "p-4 flex items-center justify-between") do
        div(class: "flex items-center gap-x-4") do
          render Components::Shared::Avatar.new(user: project_user.user, url: nil, size: "w-10 h-10")

          div do
            p(class: "font-semibold text-text") { project_user.user.name }
            p(class: "text-sm text-subtext0") do
              if project_user.added_by
                "Added by #{project_user.added_by.name} on #{project_user.created_at}"
              else
                "Joined on #{project_user.created_at}"
              end
            end
          end
        end

        div(class: "flex items-center gap-x-4") do
          render_role_badge
          render_edit_button
          render_delete_button
        end
      end
    end
  end

  private

  def render_role_badge
    role = project_user.role
    badge_colors = {
      "owner" => "bg-accent text-crust",
      "member" => "bg-primary text-crust"
    }
    color_classes = badge_colors[role] || "bg-surface2 text-text"

    span(class: "px-2 py-1 text-xs font-bold rounded-full #{color_classes}") do
      role.capitalize
    end
  end

  def render_edit_button
    return unless policy(project_user.project).edit_member?
    return if project_user.user == current_user

    link_to edit_project_member_path(project_user.project, project_user), class: "p-1 rounded-full hover:bg-crust transition-colors duration-200 cursor-pointer" do
      render Components::Icons::Edit.new(class: "w-4 h-4 text-text")
    end
  end

  def render_delete_button
    return unless policy(project_user.project).remove_member?
    return if project_user.user == current_user

    simple_form_for(project_user, url: project_member_path(project_user.project, project_user), method: :delete, data: { turbo_confirm: "Are you sure you want to remove #{project_user.user.name} from the project?" }) do |f|
      button(type: "submit", class: "p-1 rounded-full hover:text-danger transition-colors duration-200 cursor-pointer") do
        render Components::Icons::Delete.new(class: "w-4 h-4 text-red")
      end
    end
  end
end
