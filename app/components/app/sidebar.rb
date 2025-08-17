class Components::App::Sidebar < Components::Base
  include Phlex::Rails::Helpers::ClassNames

  def view_template
    aside(class: "flex flex-col w-64 flex-shrink-0 bg-surface0 border-r border-crust") do
      # Top part with New Story button
      div(class: "p-4") do
        a(href: "#", class: "w-full flex items-center justify-center gap-x-2 bg-mauve text-crust font-bold rounded-lg hover:opacity-90 transition-opacity shadow-lg shadow-mauve/20 px-4 py-2.5") do
          # Plus icon
          svg(class: "h-5 w-5", viewBox: "0 0 20 20", fill: "currentColor", "aria-hidden": "true") do |svg|
            svg.path(fill_rule: "evenodd", d: "M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z", clip_rule: "evenodd")
          end
          span { "Add Story" }
        end
      end

      # Navigation
      nav(class: "flex-1 flex flex-col p-4 space-y-2") do
        nav_item(text: "My Work", icon: :my_work, active: true)
        nav_item(text: "Current/Backlog", icon: :current_backlog)
        nav_item(text: "Icebox", icon: :icebox)
        nav_item(text: "Epics", icon: :epics)
        nav_item(text: "Reports", icon: :reports)
      end

      # Bottom part (e.g., for docs or help)
      div(class: "mt-auto p-4") do
        nav_item(text: "Help & Documentation", icon: :help)
      end
    end
  end

  private

  def nav_item(text:, icon:, active: false)
    base_classes = "flex items-center gap-x-3 rounded-md px-3 py-2 text-sm font-semibold transition-colors"
    active_classes = "bg-surface1 text-text"
    inactive_classes = "text-subtext0 hover:bg-surface1 hover:text-text"

    a(href: "#", class: class_names(base_classes, active ? active_classes : inactive_classes)) do
      render_icon(icon)
      span { text }
    end
  end

  def render_icon(name)
    # In a real app, you'd have a proper icon library.
    # Here are simple SVG placeholders.
    case name
    when :my_work
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z") }
    when :current_backlog
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z") }
    when :icebox
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M16.5 0c2.485 0 4.5 2.015 4.5 4.5 0 1.24-.504 2.36-1.318 3.182c-.03.03-.06.06-.09.09L12 15.43l-7.092-7.658c-.03-.03-.06-.06-.09-.09C4.004 6.86 3.5 5.74 3.5 4.5C3.5 2.015 5.515 0 8 0h8.5zM4.5 18a1.5 1.5 0 00-1.5 1.5v3a1.5 1.5 0 001.5 1.5h15a1.5 1.5 0 001.5-1.5v-3a1.5 1.5 0 00-1.5-1.5h-15z") }
    when :epics
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5") }
    when :reports
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M3.75 3v18h18V3H3.75zM9 18.75v-6.75m6 6.75v-3.75m-3-6v-3.75") }
    when :help
      svg(class: "h-5 w-5", fill: "none", viewBox: "0 0 24 24", stroke_width: "1.5", stroke: "currentColor") { |s| s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z") }
    end
  end
end
