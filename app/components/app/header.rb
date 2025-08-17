class Components::App::Header < Components::Base
  def view_template
    header(class: "bg-surface0 border-b border-crust flex-shrink-0") do
      div(class: "flex items-center justify-between p-4") do
        # Left Side
        div(class: "flex items-center gap-x-4") do
          a(href: app_path, class: "text-xl font-bold text-text") { "Tribely" }
          span(class: "h-6 w-px bg-crust", "aria-hidden": "true")

          # Project Switcher (Static Example)
          button(class: "flex items-center gap-x-2 rounded-md px-3 py-1.5 text-text hover:bg-surface1") do
            # Placeholder for project icon
            span(class: "w-5 h-5 bg-green/50 rounded-sm")
            span(class: "font-semibold") { "My Main Project" }
            # Chevron down icon
            render Components::Icons::ChevronDown.new(class: "h-5 w-5 text-subtext0")
          end
        end

        # Middle - Search Bar
        div(class: "w-full max-w-md ml-8") do
          label(for: "search", class: "sr-only") { "Search" }
          div(class: "relative") do
            div(class: "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3") do
              render Components::Icons::Search.new(class: "h-5 w-5 text-subtext0")
            end
            input(id: "search", name: "search", class: "block w-full rounded-md border-0 bg-surface1 py-2 pl-10 pr-3 text-text placeholder:text-subtext0 focus:ring-2 focus:ring-inset focus:ring-mauve", placeholder: "Search tasks...")
          end
        end

        # Right Side
        div(class: "flex items-center gap-x-4") do
          # Notifications
          button(type: "button", class: "rounded-full p-2 text-subtext0 hover:text-text hover:bg-surface1") do
            span(class: "sr-only") { "View notifications" }
            render Components::Icons::Bell.new(class: "h-6 w-6")
          end

          # Profile dropdown
          div(class: "relative", data: { controller: "app--header-dropdown" }) do
            button(
              type: "button",
              class: "flex items-center max-w-xs rounded-full text-sm focus:outline-none focus:ring-2 focus:ring-mauve focus:ring-offset-2 focus:ring-offset-surface0",
              data: { action: "click->app--header-dropdown#toggle" }
            ) do
              span(class: "sr-only") { "Open user menu" }
              # Avatar placeholder
              div(class: "flex items-center justify-center h-9 w-9 rounded-full bg-blue text-crust font-bold text-lg") do
                span { view_context.current_user.email.first.upcase }
              end
            end

            # Dropdown menu
            div(
              class: "hidden absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-surface1 py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none",
              data: { "app--header-dropdown-target": "menu" }
            ) do
              a(href: edit_user_registration_path, class: "block px-4 py-2 text-sm text-text hover:bg-surface2") { "Your Profile" }
              a(
                href: destroy_user_session_path,
                class: "block px-4 py-2 text-sm text-text hover:bg-surface2",
                data: { turbo_method: :delete }
              ) { "Sign out" }
            end
          end
        end
      end
    end
  end
end
