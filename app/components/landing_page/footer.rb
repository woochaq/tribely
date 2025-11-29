class Components::LandingPage::Footer < Components::Base
  def view_template
    footer do
      div(class: "w-full px-6 py-8 text-center text-subtext0 text-sm") do
        div(class: "flex justify-center gap-4 mb-4") do
          a(href: "/terms", class: "hover:text-text transition-colors") { "Terms of Service" }
          a(href: "/privacy", class: "hover:text-text transition-colors") { "Privacy Policy" }
          button(
            type: "button",
            data: { controller: "cookie-reset", action: "click->cookie-reset#reset" },
            class: "hover:text-text transition-colors cursor-pointer"
          ) { "Cookie Settings" }
        end
        p { "© #{Time.now.year} Tribely. All rights reserved." }
      end
    end
  end
end
