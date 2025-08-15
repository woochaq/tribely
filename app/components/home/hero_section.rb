class Components::Home::HeroSection < Components::Base
  def view_template
    section(id: "hero", class: "py-16 md:py-24") do
      div(class: "container mx-auto px-6 text-center") do
        div(class: "max-w-3xl mx-auto") do
          h1(class: "text-4xl md:text-6xl font-extrabold text-text leading-tight reveal-on-scroll is-visible") do
            "Manage IT Projects with Clarity and Style"
          end
          p(class: "mt-6 text-lg text-subtext0 leading-relaxed reveal-on-scroll is-visible", style: "--animation-delay: 150ms;") do
            "Our tool combines powerful task, project, and team management, inspired by the minimalist philosophy and aesthetics of Hyprland."
          end
          div(class: "mt-10 flex flex-col sm:flex-row justify-center items-center gap-4 reveal-on-scroll is-visible", style: "--animation-delay: 300ms;") do
            a(href: "#", class: "py-3 px-6 font-semibold text-crust bg-peach rounded-lg hover:opacity-90 transition-opacity w-full sm:w-auto") do
              "Get Started for Free"
            end
            a(href: "#", class: "py-3 px-6 font-semibold text-text border-2 border-crust rounded-lg bg-mantle hover:bg-crust transition-colors w-full sm:w-auto") do
              "Watch Demo"
            end
          end
        end
        div(class: "mt-16 bg-mantle border border-crust rounded-2xl h-96 flex items-center justify-center shadow-lg shadow-crust/20 reveal-on-scroll is-visible", style: "--animation-delay: 450ms;") do
          p(class: "text-subtext0") do
            "[Clean, visually appealing screenshot of the app's dashboard]"
          end
        end
      end
    end
  end
end
