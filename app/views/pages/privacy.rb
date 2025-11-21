module Views
  module Pages
    class Privacy < Views::Base
      def view_template
        div(class: "container mx-auto px-6 py-12 max-w-3xl") do
          h1(class: "text-3xl font-bold mb-6 text-text") { "Privacy Policy" }
          div(class: "prose prose-invert text-subtext0") do
            p { "Last updated: #{Date.today.strftime('%B %d, %Y')}" }

            p { "At Tribely, we take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your information when you use our project management platform." }

            h2 { "1. Information We Collect" }
            p { "We collect information you provide directly to us:" }
            ul do
              li { "Account Information: Name, email address, and password." }
              li { "Project Data: Tasks, stories, comments, and files you upload to the platform." }
            end

            h2 { "2. How We Use Your Information" }
            p { "We use the information we collect to:" }
            ul do
              li { "Provide, maintain, and improve our services." }
              li { "Process transactions and send related information." }
              li { "Send you technical notices, updates, and support messages." }
            end

             h2 { "3. Cookies & Tracking" }
            p { "We use cookies to ensure the website functions correctly and to analyze traffic." }
            ul do
              li do
                strong { "Essential Cookies: " }
                plain "Necessary for logging in and secure navigation. These cannot be disabled."
              end
              li do
                strong { "Analytics Cookies: " }
                plain "(Optional) We use Umami Analytics (a privacy-focused tool) to understand how our website is used. You can opt-out of these cookies at any time."
              end
            end
            h2 { "4. Data Sharing & Third Parties" }
            p { "We do not sell your personal data. We share information only with trusted third-party service providers necessary to operate our services:" }
            ul do
              li { "Payment Processors (e.g., Stripe) for secure billing." }
              li { "Email Providers for sending transactional notifications." }
              li { "Hosting & Infrastructure providers to run the platform securely." }
            end

            h2 { "5. Data Retention & Security" }
            p { "We retain your personal information for as long as your account is active or as needed to provide you services. We implement industry-standard security measures (SSL, encryption) to protect your data." }

            h2 { "6. Your Rights" }
            p { "Depending on your location (e.g., GDPR in Europe), you may have the right to:" }
            ul do
              li { "Access the personal data we hold about you." }
              li { "Request correction of inaccurate data." }
              li { "Request deletion of your account and data ('Right to be forgotten')." }
              li { "Export your data." }
            end

            h2 { "7. Contact Us" }
            p do
              plain "If you have any questions about this Privacy Policy or wish to exercise your rights, please contact us at: "
              a(href: "mailto:contact@tribely.work", class: "text-primary hover:underline") { "contact@tribely.work" }
            end
          end
        end
      end
    end
  end
end
