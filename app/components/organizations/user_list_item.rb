class Components::Organizations::UserListItem < Components::Base
  attr_reader :organization_user

  def initialize(organization_user:)
    @organization_user = organization_user
  end

  def view_template
    li(class: "p-4 flex items-center justify-between") do
      div(class: "flex items-center gap-x-4") do
        render Components::Shared::Avatar.new(user: organization_user.user, url: nil, size: "w-10 h-10")

        div do
          p(class: "font-semibold text-text") { organization_user.user.name }
          p(class: "text-sm text-subtext0") { "Joined #{organization_user.created_at}" }
        end
      end

      render_role_badge
    end
  end

  private

  def render_role_badge
    role = organization_user.role
    badge_colors = {
      "owner" => "bg-accent text-crust",
      "member" => "bg-primary text-crust"
    }
    color_classes = badge_colors[role] || "bg-surface2 text-text"

    span(class: "px-2 py-1 text-xs font-bold rounded-full #{color_classes}") do
      role.capitalize
    end
  end
end
