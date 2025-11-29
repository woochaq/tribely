class Views::Pages::Terms < Views::Base
  def view_template
    div(class: "container mx-auto px-6 py-12 max-w-3xl") do
      h1(class: "text-3xl font-bold mb-6 text-text") { "Terms of Service" }
      div(class: "prose prose-invert text-subtext0") do
        p { "Last updated: #{Date.today.strftime('%B %d, %Y')}" }

        p { "Welcome to Tribely! By creating an account or using our services, you agree to be bound by these Terms of Service. Please read them carefully." }

        h2 { "1. Acceptance of Terms" }
        p { "By accessing or using Tribely, you agree to comply with and be bound by these Terms. If you do not agree to these Terms, you may not use our services." }

        h2 { "2. Description of Service" }
        p { "Tribely is a project management and collaboration platform. We provide tools for teams to organize tasks, stories, and documentation." }

        h2 { "3. User Accounts" }
        p { "To access certain features, you must create an account. You agree to:" }
        ul do
          li { "Provide accurate and complete information." }
          li { "Maintain the security of your password." }
          li { "Accept responsibility for all activities that occur under your account." }
        end

        h2 { "4. User Content" }
        p { "You retain ownership of any content you upload, submit, or display on Tribely ('User Content'). However, by submitting User Content, you grant us a worldwide, non-exclusive, royalty-free license to use, host, store, and display your content solely for the purpose of providing the service to you." }
        p { "You agree not to upload content that is illegal, offensive, or violates the rights of others." }

        h2 { "5. Termination" }
        p { "We reserve the right to suspend or terminate your account at any time for violation of these Terms or for any other reason, with or without notice." }

        h2 { "6. Limitation of Liability" }
        p { "Tribely is provided 'as is' without warranties of any kind. In no event shall Tribely or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit) arising out of the use or inability to use the service." }

        h2 { "7. Changes to Terms" }
        p { "We may modify these Terms at any time. We will notify users of significant changes. Your continued use of the service after such changes constitutes your acceptance of the new Terms." }

        h2 { "8. Contact Us" }
        p do
          plain "If you have any questions about these Terms, please contact us at: "
          a(href: "mailto:contact@tribely.work", class: "text-primary hover:underline") { "contact@tribely.work" }
        end
      end
    end
  end
end
