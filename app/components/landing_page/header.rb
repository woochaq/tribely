class Components::LandingPage::Header < Components::Base
  include Phlex::Rails::Helpers::LinkTo

  def view_template
     header(class: "fixed top-0 left-0 w-full z-50") do
      div(class: "w-full px-6 py-4") do
        nav(class: "w-full bg-mantle/70 backdrop-blur-xl border border-crust/50 rounded-2xl flex justify-between items-center px-6 py-3") do
          a(href: projects_path, class: "flex items-center gap-x-2") do
            img(src: view_context.image_path("logo.webp"), alt: "Tribely Logo", class: "h-10 w-auto")
            span(class: "text-xl font-bold text-text") { "Tribely" }
          end

          div(class: "hidden md:flex items-center space-x-8") do
            a(href: "#features", class: "font-semibold text-subtext0 hover:text-primary transition-colors") { "Features" }
            a(href: "#pricing", class: "font-semibold text-subtext0 hover:text-primary transition-colors") { "Pricing" }
            a(href: "#", class: "font-semibold text-subtext0 hover:text-primary transition-colors") { "Docs" }
          end

           div(class: "flex items-center space-x-4") do
            if view_context.user_signed_in?
              div(class: "flex items-center gap-4") do
                link_to projects_path do
                  render Components::Shared::Avatar.new(user: view_context.current_user, url: nil, size: "w-10 h-10")
                end
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
