class Components::Shared::CookieConsent < Components::Base
  def view_template
    div(
      data: {
        controller: "cookie-consent",
        cookie_consent_website_id_value: "5c565357-721e-4784-a47d-3aeeba73e86a", # Umami ID
        "cookie-consent-target": "banner"
      },
      class: "hidden fixed bottom-4 left-4 right-4 md:left-auto md:right-4 md:max-w-md z-[100] bg-surface0 border border-crust shadow-xl rounded-lg p-6 animate-in fade-in slide-in-from-bottom-4 duration-500"
    ) do
      div(class: "flex items-start gap-4") do
        div(class: "text-2xl") { "🍪" }
        div(class: "flex-1") do
          h3(class: "font-bold text-text mb-1") { "Cookie Preferences" }
          p(class: "text-sm text-subtext0 mb-4") do
            plain "We use essential cookies to ensure the site functions correctly. We'd also like to use analytics cookies to improve your experience."
            a(href: "/privacy", class: "text-primary hover:underline") { "Privacy Policy" }
          end

          div(class: "flex gap-2") do
            button(
              class: "btn-primary text-sm px-4 py-2",
              data: { action: "click->cookie-consent#accept" }
            ) { "Accept Analytics" }

            button(
              class: "btn-secondary text-sm px-4 py-2",
              data: { action: "click->cookie-consent#decline" }
            ) { "Reject Analytics" }
          end
        end
      end
    end
  end
end
