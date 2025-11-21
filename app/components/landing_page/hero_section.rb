class Components::LandingPage::HeroSection < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ImageTag

  def view_template
    section(id: "hero", class: "relative overflow-hidden py-20 md:py-32") do
      div(class: "absolute top-0 left-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2", "aria-hidden": "true")
      div(class: "absolute bottom-0 right-0 w-96 h-96 bg-info/10 rounded-full blur-3xl translate-x-1/2 translate-y-1/2", "aria-hidden": "true")

      div(class: "w-full px-6 text-center relative") do
        div(class: "max-w-3xl mx-auto") do
          h1(class: "text-4xl md:text-6xl font-extrabold text-text leading-tight") do
            "Manage Projects with Clarity and Style"
          end
          p(class: "mt-6 text-lg text-subtext0 leading-relaxed ") do
            "Our tool combines powerful task, project, and team management, inspired by the minimalist philosophy and aesthetics of Hyprland."
          end
          div(class: "mt-10 flex flex-col sm:flex-row justify-center items-center gap-4") do
            link_to "Get Started", new_user_registration_path, class: "py-3 px-6 w-full sm:w-auto bg-primary text-crust font-bold rounded-lg hover:opacity-90 transition-opacity shadow-lg shadow-primary/20"
            a(href: "/docs", class: "py-3 px-6 w-full sm:w-auto bg-base hover:bg-surface0 border-2 border-surface1 font-semibold text-text rounded-lg transition-colors") do
              "Read Documentation"
            end
          end
        end

        div(class: "mt-20 w-full max-w-4xl mx-auto bg-base/50 backdrop-blur-xl rounded-2xl border-2 border-surface0 shadow-2xl shadow-crust/30 reveal-on-scroll is-visible overflow-hidden") do
          div(class: "flex items-center gap-2 p-4 border-b-2 border-surface0 bg-mantle/50") do
            div(class: "w-3 h-3 rounded-full bg-danger")
            div(class: "w-3 h-3 rounded-full bg-warning")
            div(class: "w-3 h-3 rounded-full bg-success")
          end

          div(class: "w-full bg-mantle flex items-center justify-center") do
            image_tag("board.webp", class: "w-full h-auto", alt: "Tribely Board Preview")
          end
        end
      end
    end
  end
end
