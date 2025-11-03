class Components::Shared::HeaderAvatar < Components::Base
  def initialize(user:)
    @user = user
  end

  def view_template
    RubyUI::Popover(options: { placement: "bottom-end" }) do
      PopoverTrigger(class: "w-full") do
        render Components::Shared::Avatar.new(user: current_user, url: nil, size: "w-10 h-10")
      end
      PopoverContent(class: "w-48 origin-top-right bg-surface1 py-1 shadow-lg border-black ring-opacity-5 focus:outline-none") do
        Link(href: edit_user_registration_path, variant: :ghost, class: "w-full justify-start pl-2 text-sm text-text hover:text-text hover:bg-surface2") do
          render Components::Icons::Profile.new(class: "h-5 w-5 mr-2")
          plain "Profile"
        end
        Link(href: projects_path, variant: :ghost, class: "w-full justify-start pl-2 text-sm text-text hover:text-text hover:bg-surface2") do
          render Components::Icons::Folder.new(class: "h-5 w-5 mr-2")
          plain "Projects"
        end
        Link(href: "#", variant: :ghost, class: "w-full justify-start pl-2 text-sm text-text hover:text-text hover:bg-surface2") do
          render Components::Icons::Settings.new(class: "h-5 w-5 mr-2")
          plain "Settings"
        end
        Link(href: destroy_user_session_path, variant: :ghost, class: "w-full justify-start pl-2 text-sm text-text hover:text-text hover:bg-surface2", data: { turbo_method: :delete }) do
          render Components::Icons::Logout.new(class: "h-5 w-5 mr-2")
          plain "Logout"
        end
      end
    end
  end
end
