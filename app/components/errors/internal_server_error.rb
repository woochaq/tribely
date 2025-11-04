# frozen_string_literal: true

class Components::Errors::InternalServerError < Components::Base
  def view_template
    main(class: "grid min-h-full place-items-center bg-crust px-6 py-24 sm:py-32 lg:px-8") do
      div(class: "text-center") do
        p(class: "text-base font-semibold text-primary") { "500" }
        h1(class: "mt-4 text-3xl font-bold tracking-tight text-text sm:text-5xl") { "Something went wrong" }
        p(class: "mt-6 text-base leading-7 text-subtext0") { "We've been notified about the issue and are working to fix it." }
        div(class: "mt-10 flex items-center justify-center gap-x-6") do
          if current_user
            a(href: projects_path, class: "btn-primary") { "Go back to projects" }
          else
            a(href: "/", class: "btn-primary") { "Go back home" }
          end
        end
      end
    end
  end
end
