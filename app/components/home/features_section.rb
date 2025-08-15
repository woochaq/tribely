class Components::Home::FeaturesSection < Components::Base
  def view_template
    section(id: "features", class: "py-24 bg-mantle") do
      div(class: "container mx-auto px-6") do
        div(class: "max-w-2xl mx-auto text-center") do
          h2(class: "text-3xl md:text-4xl font-bold text-text mb-12 reveal-on-scroll") do
            "Everything You Need in One Place"
          end
        end
        div(class: "grid md:grid-cols-3 gap-8") do
          div(class: "bg-base border border-crust rounded-2xl p-8 reveal-on-scroll") do
            h3(class: "text-xl font-bold text-text") do
              "Smart Task Management"
            end
            p(class: "mt-2 text-subtext0") do
              "Organize, assign, and track tasks with an intuitive and flexible system designed for speed."
            end
          end
          div(class: "bg-base border border-crust rounded-2xl p-8 reveal-on-scroll", style: "--animation-delay: 150ms;") do
            h3(class: "text-xl font-bold text-text") do
              "Real-time Collaboration"
            end
            p(class: "mt-2 text-subtext0") do
              "Work with your team seamlessly with shared boards, live updates, and integrated communication."
            end
          end
          div(class: "bg-base border border-crust rounded-2xl p-8 reveal-on-scroll", style: "--animation-delay: 300ms;") do
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
