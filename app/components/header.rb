class Components::Header < Components::Base
  def view_template
     header(class: "fixed top-0 left-0 w-full z-50") do
      div(class: "w-full px-6 py-4") do
        nav(class: "w-full bg-mantle/70 backdrop-blur-xl border border-crust/50 rounded-2xl flex justify-between items-center px-6 py-3") do
          a(href: root_path, class: "text-xl font-bold text-text") { "Tribely" }

          div(class: "hidden md:flex items-center space-x-8") do
            a(href: "#features", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Features" }
            a(href: "#pricing", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Pricing" }
            a(href: "#", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Docs" }
          end

           div(class: "flex items-center space-x-4") do
            if view_context.user_signed_in?
              div(class: "flex items-center gap-4") do
                a(href: edit_user_registration_path, class: "flex items-center justify-center h-10 w-10 rounded-full bg-mauve text-crust font-bold text-lg hover:opacity-90 transition-opacity", title: "Edit profile") do
                  span { view_context.current_user.email.first.upcase }
                end
                a(href: destroy_user_session_path, data: { turbo_method: :delete }, class: "btn-secondary py-2 px-5") { "Logout" }
              end
            else
              a(href: new_user_session_path, class: "btn-secondary py-2 px-5") { "Login" }
              a(href: new_user_registration_path, class: "btn-primary") { "Sign Up" }
            end
          end
        end
      end
    end
  end
end
