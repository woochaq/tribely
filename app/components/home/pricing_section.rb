class Components::Home::PricingSection < Components::Base
  def view_template
    section(id: "pricing", class: "py-24") do
      div(class: "container mx-auto px-6") do
        div(class: "max-w-2xl mx-auto text-center") do
          h2(class: "text-3xl md:text-4xl font-bold text-text mb-12 reveal-on-scroll") do
            "Choose the Perfect Plan for You"
          end
        end
        div(class: "grid lg:grid-cols-3 gap-8 max-w-4xl mx-auto") do
          div(class: "bg-mantle border border-crust rounded-2xl p-8 text-center flex flex-col reveal-on-scroll") do
            h3(class: "text-2xl font-bold text-text") do
              "Free"
            end
            p(class: "text-4xl font-bold my-4") do
              plain "$0"
              span(class: "text-lg font-normal text-subtext0") do
                "/month"
              end
            end
            ul(class: "space-y-3 text-subtext0 text-left my-6") do
              li { "✓ Up to 3 Projects" }
              li { "✓ Basic Task Management" }
              li { "✓ Community Support" }
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 font-semibold text-text border-2 border-crust rounded-lg hover:bg-crust transition-colors") do
              "Get Started"
            end
          end

          div(class: "bg-mantle border-2 border-mauve rounded-2xl p-8 text-center flex flex-col transform lg:scale-105 shadow-2xl shadow-crust/20 reveal-on-scroll", style: "--animation-delay: 150ms;") do
            h3(class: "text-2xl font-bold text-text") do
              "Pro"
            end
            p(class: "text-4xl font-bold my-4") do
              plain "$12"
              span(class: "text-lg font-normal text-subtext0") { "/user/month" }
            end
            ul(class: "space-y-3 text-subtext0 text-left my-6") do
              li { "✓ Unlimited Projects" }
              li { "✓ Advanced Dashboards" }
              li { "✓ Integrations & Priority Support" }
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 font-semibold text-crust bg-peach rounded-lg hover:opacity-90 transition-opacity") do
              "Choose Pro"
            end
          end

          div(class: "bg-mantle border border-crust rounded-2xl p-8 text-center flex flex-col reveal-on-scroll", style: "--animation-delay: 300ms;") do
            h3(class: "text-2xl font-bold text-text") { "Enterprise" }
            p(class: "text-4xl font-bold my-4") { "Contact Us " }
            ul(class: "space-y-3 text-subtext0 text-left my-6") do
              li { "✓ Dedicated Onboarding" }
              li { "✓ Custom Integrations" }
              li { "✓ 24/7 Premium Support" }
            end
            a(href: "#", class: "mt-auto block w-full py-3 px-6 font-semibold text-text border-2 border-crust rounded-lg hover:bg-crust transition-colors") do
              "Contact Sales"
            end
          end
        end
      end
    end
  end
end
