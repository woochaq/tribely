class Components::AppLayout < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::JavaScriptImportmapTags
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::TurboRefreshesWith

  def initialize(title: "Tribely App", current_project: nil)
    @title = title
    @current_project = current_project
  end

  def view_template(&block)
    doctype

    html(lang: "en", class: "h-full bg-base", data: { theme: "catppuccin" }) do
      head do
        title { @title }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        meta name: "apple-mobile-web-app-capable", content: "yes"
        meta name: "mobile-web-app-capable", content: "yes"
        meta name: "description", content: "Tribely: Streamline your workflow with our intuitive project management tool. Manage projects, track stories, and collaborate with your team effortlessly."
        turbo_refreshes_with method: :morph, scroll: :preserve
        csrf_meta_tags
        csp_meta_tag
        content_for :head

        # Google Fonts
        link rel: "preconnect", href: "https://fonts.googleapis.com"
        link rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous"
        link href: "https://fonts.googleapis.com/css2?family=Cascadia+Mono:wght@400;700&display=swap", rel: "stylesheet"

        render Components::Shared::Favicon.new
        stylesheet_link_tag "lexxy", "data-turbo-track": "reload"
        stylesheet_link_tag :app, "data-turbo-track": "reload"
        javascript_importmap_tags
      end

      body(class: "h-full font-sans text-text", data: { "current-user-id": current_user&.id }) do
        render Components::Shared::FlashMessages.new

        div(class: "flex flex-col h-full", data: { controller: "mobile-navigation" }) do
          render Components::App::Header.new(current_project: @current_project)

          div(class: "flex flex-1 overflow-hidden") do
            render Components::App::Sidebar.new(current_project: @current_project)
            main(class: "flex-1 flex flex-col p-4 sm:p-6lg:p-8 overflow-y-auto", &block)
          end
        end
        render Components::Shared::Modal
        render Components::Shared::CookieConsent.new
      end
    end
  end
end
