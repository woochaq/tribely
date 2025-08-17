class Components::LandingPage::HeroSection < Components::Base
  def view_template
    section(id: "hero", class: "relative overflow-hidden py-20 md:py-32") do
      # Background decorative gradients
      div(class: "absolute top-0 left-0 w-96 h-96 bg-mauve/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2", "aria-hidden": "true")
      div(class: "absolute bottom-0 right-0 w-96 h-96 bg-blue/10 rounded-full blur-3xl translate-x-1/2 translate-y-1/2", "aria-hidden": "true")

      div(class: "w-full px-6 text-center relative") do
        div(class: "max-w-3xl mx-auto") do
          h1(class: "text-4xl md:text-6xl font-extrabold text-text leading-tight reveal-on-scroll is-visible") do
            "Manage IT Projects with Clarity and Style"
          end
          p(class: "mt-6 text-lg text-subtext0 leading-relaxed reveal-on-scroll is-visible", style: "--animation-delay: 150ms;") do
            "Our tool combines powerful task, project, and team management, inspired by the minimalist philosophy and aesthetics of Hyprland."
          end
          div(class: "mt-10 flex flex-col sm:flex-row justify-center items-center gap-4 reveal-on-scroll is-visible", style: "--animation-delay: 300ms;") do
            a(href: "#", class: "py-3 px-6 w-full sm:w-auto bg-mauve text-crust font-bold rounded-lg hover:opacity-90 transition-opacity shadow-lg shadow-mauve/20") do
              "Get Started for Free"
            end
            a(href: "#", class: "py-3 px-6 w-full sm:w-auto bg-base hover:bg-surface0 border-2 border-surface1 font-semibold text-text rounded-lg transition-colors") do
              "Watch Demo"
            end
          end
        end

        # Stylized app screenshot placeholder
        div(class: "mt-20 w-full max-w-4xl mx-auto bg-base/50 backdrop-blur-xl rounded-2xl border-2 border-surface0 shadow-2xl shadow-crust/30 reveal-on-scroll is-visible", style: "--animation-delay: 450ms;") do
          # Browser header
          div(class: "flex items-center gap-2 p-4 border-b-2 border-surface0") do
            div(class: "w-3 h-3 rounded-full bg-red")
            div(class: "w-3 h-3 rounded-full bg-yellow")
            div(class: "w-3 h-3 rounded-full bg-green")
          end
          # Content area
          div(class: "p-8 h-96 flex items-center justify-center") do
            p(class: "text-subtext0 text-lg") { "Your beautiful app screenshot here." }
          end
        end
      end
    end
  end
end
