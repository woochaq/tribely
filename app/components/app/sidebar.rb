class Components::App::Sidebar < Components::Base
  include Phlex::Rails::Helpers::ClassNames

  def initialize(current_project:)
    @current_project = current_project
  end

  def view_template
    return if @current_project.nil?
    aside(class: class_names("flex flex-col w-64 flex-shrink-0 bg-surface0 border-r border-crust", "hidden": !@current_project.present?)) do
      # Top part with New Story button
      div(class: "p-4") do
        a(href: "#", class: "w-full flex items-center justify-center gap-x-2 bg-primary text-crust font-bold rounded-lg hover:opacity-90 transition-opacity shadow-lg shadow-primary/20 px-4 py-2.5") do
          # Plus icon
          render Components::Icons::Plus.new(class: "h-5 w-5")
          span { "Add Story" }
        end
      end

      # Navigation
      nav(class: "flex-1 flex flex-col p-4 space-y-2") do
        nav_item(text: "My Work", icon: :my_work, active: true)
        div(class: "flex items-center justify-between px-3 py-2") do
          span { "Boards" }
          span do
            render Components::Icons::Plus.new
          end
        end
        hr
        @current_project.boards.each do |board|
          nav_item(text: board.name, icon: :current)
        end
        hr
        nav_item(text: "Reports", icon: :reports)
        nav_item(text: "Settings", icon: :settings)
      end

      # Bottom part (e.g., for docs or help)
      # div(class: "mt-auto p-4") do
      #  nav_item(text: "Help & Documentation", icon: :help)
      # end
    end
  end

  private

  def nav_item(text:, icon:, active: false)
    base_classes = "flex items-center gap-x-3 rounded-md px-3 py-2 text-sm font-semibold transition-colors"
    active_classes = "bg-surface1 text-accent"
    inactive_classes = "text-subtext0 hover:bg-surface1 hover:text-text"

    a(href: "#", class: class_names(base_classes, active ? active_classes : inactive_classes)) do
      render_icon(icon)
      span { text }
    end
  end

  def render_icon(name)
    case name
    when :my_work
      render Components::Icons::User.new(class: "h-5 w-5")
    when :current
      render Components::Icons::Folder.new(class: "h-5 w-5")
    when :icebox
      render Components::Icons::Cube.new(class: "h-5 w-5")
    when :epics
      render Components::Icons::Bars3.new(class: "h-5 w-5")
    when :reports
      render Components::Icons::ChartBar.new(class: "h-5 w-5")
    when :settings
      render Components::Icons::Settings.new(class: "h-5 w-5")
    when :help
      render Components::Icons::QuestionMarkCircle.new(class: "h-5 w-5")
    end
  end
end
