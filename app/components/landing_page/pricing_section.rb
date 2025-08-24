class Components::LandingPage::PricingSection < Components::Base
  def view_template
    section(id: "pricing", class: "py-24 bg-base") do
      div(class: "w-full px-6") do
        div(class: "max-w-2xl mx-auto text-center") do
          h2(class: "text-3xl md:text-4xl font-bold text-text mb-4 reveal-on-scroll") do
            "Choose the Perfect Plan for You"
          end
          p(class: "text-lg text-subtext0 reveal-on-scroll", style: "--animation-delay: 100ms;") do
            "Simple, transparent pricing. Choose the plan that fits your needs and scale as you grow."
          end
        end
        div(class: "grid lg:grid-cols-3 gap-8 max-w-5xl mx-auto mt-16") do
          # Free Plan
          div(class: "bg-surface0 border border-crust rounded-2xl p-8 flex flex-col transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-crust/30 reveal-on-scroll") do
            h3(class: "text-2xl font-bold text-text") { "Free" }
            p(class: "text-4xl font-bold my-4 text-text") do
              plain "$0"
              span(class: "text-lg font-normal text-subtext0") { "/month" }
            end
            ul(class: "space-y-4 text-subtext0 my-6 text-left") do
              feature_item("Up to 3 Projects")
              feature_item("Basic Task Management")
              feature_item("Community Support")
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 bg-surface1 hover:bg-surface2 border-2 border-surface2 font-semibold text-text rounded-lg transition-colors text-center") do
              "Get Started"
            end
          end

          # Pro Plan (Highlighted)
          div(class: "relative bg-mantle border-2 border-primary rounded-2xl p-8 flex flex-col transform lg:scale-105 shadow-2xl shadow-primary/20 reveal-on-scroll", style: "--animation-delay: 150ms;") do
            div(class: "absolute -top-4 left-1/2 -translate-x-1/2") do
              span(class: "bg-primary text-crust text-xs font-bold uppercase tracking-wider px-4 py-1 rounded-full") { "Most Popular" }
            end
            h3(class: "text-2xl font-bold text-text") { "Pro" }
            p(class: "text-4xl font-bold my-4 text-text") do
              plain "$12"
              span(class: "text-lg font-normal text-subtext0") { "/user/month" }
            end
            ul(class: "space-y-4 text-subtext0 my-6 text-left") do
              feature_item("Unlimited Projects")
              feature_item("Advanced Dashboards")
              feature_item("Integrations & Priority Support")
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 bg-primary text-crust font-bold rounded-lg hover:opacity-90 transition-opacity text-center") do
              "Choose Pro"
            end
          end

          # Enterprise Plan
          div(class: "bg-surface0 border border-crust rounded-2xl p-8 flex flex-col transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-2xl hover:shadow-crust/30 reveal-on-scroll", style: "--animation-delay: 300ms;") do
            h3(class: "text-2xl font-bold text-text") { "Enterprise" }
            p(class: "text-4xl font-bold my-4 text-text") { "Contact Us" }
            ul(class: "space-y-4 text-subtext0 my-6 text-left") do
              feature_item("Dedicated Onboarding")
              feature_item("Custom Integrations")
              feature_item("24/7 Premium Support")
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 bg-surface1 hover:bg-surface2 border-2 border-surface2 font-semibold text-text rounded-lg transition-colors text-center") do
              "Contact Sales"
            end
          end
        end
      end
    end
  end

  private def feature_item(text)
    li(class: "flex items-center gap-x-3") do
      # Checkmark Icon
      render Components::Icons::Check.new(class: "h-6 w-6 flex-none text-success")
      span { text }
    end
  end
end
