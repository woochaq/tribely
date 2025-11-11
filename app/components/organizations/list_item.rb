class Components::Organizations::ListItem < Components::Base
  include Phlex::Rails::Helpers::ImageTag
  include Phlex::Rails::Helpers::LinkTo
  include Pundit::Authorization

  attr_reader :organization, :current_user

  def initialize(organization:, current_user:)
    @organization = organization
    @current_user = current_user
  end

  def view_template
    li(class: "p-4 flex items-center justify-between  hover:bg-surface0") do
      link_to(organization_path(organization), class: "flex-grow flex items-center gap-x-4 min-w-0") do
        div(class: "w-10 h-10 bg-surface1 rounded-lg flex-shrink-0 flex itemx-center justify-center") do
          image_tag @organization.avatar.variant(:thumb) if @organization.avatar.attached?
        end

        div(class: "truncate") do
          span(class: "font-semibold text-text") { organization.name }
        end
      end

      div(class: "flex items-center gap-x-4 flex-shrink-0") do
        render_role_badge
        if policy(organization).edit?
          link_to edit_organization_path(organization) do
            render Components::Icons::Edit.new(class: "w-5 h-5")
          end
        end
      end
    end
  end

  private

  def user_role
    @user_role ||= organization.organization_users.find_by(user_id: current_user.id)&.role
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
