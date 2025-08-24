class Components::LandingPage::FeaturesSection < Components::Base
  def view_template
    section(id: "features", class: "py-24 bg-mantle") do
      div(class: "w-full px-6") do
        div(class: "max-w-2xl mx-auto text-center") do
          h2(class: "text-3xl md:text-4xl font-bold text-text mb-4 reveal-on-scroll") do
            "Everything You Need in One Place"
          end
          p(class: "text-lg text-subtext0 reveal-on-scroll", style: "--animation-delay: 100ms;") do
            "Stop juggling between apps. Our platform provides a unified, streamlined experience for your entire workflow."
          end
        end
        div(class: "grid md:grid-cols-3 gap-8 max-w-6xl mx-auto mt-16") do
          # Feature Card 1
          div(class: "bg-surface0 border border-crust rounded-2xl p-8 transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-crust/30 reveal-on-scroll") do
            div(class: "w-12 h-12 rounded-xl bg-info/20 flex items-center justify-center mb-6") do
              # Placeholder for an SVG icon
              span(class: "text-2xl font-bold text-info") { "S" }
            end
            h3(class: "text-xl font-bold text-text") do
              "Smart Task Management"
            end
            p(class: "mt-2 text-subtext0") do
              "Organize, assign, and track tasks with an intuitive and flexible system designed for speed."
            end
          end

          # Feature Card 2
          div(class: "bg-surface0 border border-crust rounded-2xl p-8 transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-crust/30 reveal-on-scroll", style: "--animation-delay: 150ms;") do
            div(class: "w-12 h-12 rounded-xl bg-accent/20 flex items-center justify-center mb-6") do
              # Placeholder for an SVG icon
              span(class: "text-2xl font-bold text-accent") { "R" }
            end
            h3(class: "text-xl font-bold text-text") do
              "Real-time Collaboration"
            end
            p(class: "mt-2 text-subtext0") do
              "Work with your team seamlessly with shared boards, live updates, and integrated communication."
            end
          end

          # Feature Card 3
          div(class: "bg-surface0 border border-crust rounded-2xl p-8 transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-crust/30 reveal-on-scroll", style: "--animation-delay: 300ms;") do
            div(class: "w-12 h-12 rounded-xl bg-success/20 flex items-center justify-center mb-6") do
              # Placeholder for an SVG icon
              span(class: "text-2xl font-bold text-success") { "C" }
            end
            h3(class: "text-xl font-bold text-text") do
              "Customizable Dashboards"
            end
            p(class: "mt-2 text-subtext0") do
              "Create a personal workspace that shows you exactly what you need, and nothing you don't."
            end
          end
        end
      end
    end
  end
end
