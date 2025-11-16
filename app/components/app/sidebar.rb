class Components::App::Sidebar < Components::Base
  include Pundit::Authorization
  include Phlex::Rails::Helpers::ClassNames
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::CurrentPage

  def initialize(current_project:)
    @current_project = current_project
  end

  def view_template
    aside(class: "hidden lg:flex flex-col w-64 flex-shrink-0 bg-surface0 border-r border-crust", data: { "mobile-navigation-target": "sidebar" }) do
      render Components::App::Sidebar::ProjectSwitcher.new(
        current_project: @current_project,
        projects: current_user.projects
      )
      if @current_project
        nav(class: "flex-1 flex flex-col p-4 space-y-2") do
          nav_item(text: "Boards", icon: :boards, href: project_path(@current_project), active: current_page?(project_path(@current_project)))
          nav_item(text: "Documents", icon: :documents, href: project_documents_path(@current_project), active: current_page?(project_documents_path(@current_project)))
          # nav_item(text: "All Stories", icon: :all_stories, href: "#")
          # nav_item(text: "Reports", icon: :reports, href: "#")
          nav_item(text: "Project Settings", icon: :settings, href: settings_project_path(@current_project), active: current_page?(settings_project_path(@current_project)))
        end
      end

      div(class: "mt-auto") do
        nav(class: "flex flex-col p-4 space-y-2 border-t border-crust") do
          nav_item(text: "My Projects", icon: :my_projects, href: projects_path, active: current_page?(projects_path))
          nav_item(text: "My Organizations", icon: :organizations, href: organizations_path, active: current_page?(organizations_path))
          # nav_item(text: "My Stories", icon: :my_stories, href: "#")
          div(class: "flex items-center gap-x-3 rounded-md px-3 py-2") do
            link_to edit_user_registration_path do
              render Components::Shared::Avatar.new(user: current_user, url: nil, size: "w-10 h-10")
            end
            div(class: "flex flex-col truncate") do
              link_to current_user.name, edit_user_registration_path, class: "text-sm font-semibold text-text truncate"
              link_to "Logout", destroy_user_session_path, class: "text-xs text-subtext0 hover:text-text", data: { turbo_method: :delete }
            end
          end
        end
      end
    end
  end

  private

  def nav_item(text:, icon:, href: "#", active: false)
    base_classes = "flex items-center gap-x-3 rounded-md px-3 py-2 text-sm font-semibold transition-colors"
    active_classes = "bg-surface1 text-primary"
    inactive_classes = "text-subtext0 hover:bg-surface1 hover:text-text"

    link_to(href, class: class_names(base_classes, active ? active_classes : inactive_classes)) do
      render_icon(icon)
      span { text }
    end
  end

  def render_icon(name)
    case name
    when :boards
      render PhlexIcons::Bootstrap::Kanban.new(class: "size-5")
    when :documents
      render PhlexIcons::Bootstrap::FileEarmarkText.new(class: "size-5")
    when :settings
      render PhlexIcons::Bootstrap::Gear.new(class: "size-5")
    when :my_projects
      render Components::Icons::Folder.new(class: "h-5 w-5")
    when :organizations
      render PhlexIcons::Bootstrap::Building.new(class: "size-5")
    end
  end
end
