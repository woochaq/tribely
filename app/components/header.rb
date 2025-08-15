class Components::Header < Components::Base
  def view_template
     header(class: "fixed top-0 left-0 w-full z-50") do
      div(class: "container mx-auto px-6 py-4") do
        nav(class: "w-full bg-mantle/70 backdrop-blur-xl border border-crust/50 rounded-2xl flex justify-between items-center px-6 py-3") do
          a(href: "#", class: "text-xl font-bold text-text") { "Tribely" }

          div(class: "hidden md:flex items-center space-x-8") do
            a(href: "#features", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Features" }
            a(href: "#pricing", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Pricing" }
            a(href: "#", class: "font-semibold text-subtext0 hover:text-mauve transition-colors") { "Docs" }
          end

          div(class: "flex items-center space-x-4") do
            a(href: "#", class: "py-2 px-5 font-semibold text-text border-2 border-crust rounded-lg hover:bg-crust transition-colors") { "Login" }
            a(href: "#", class: "py-2 px-5 font-semibold text-crust bg-peach rounded-lg hover:opacity-90 transition-opacity") { "Sign Up" }
          end
        end
      end
    end
  end
end
