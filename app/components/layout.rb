class Components::Layout < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::JavaScriptImportmapTags
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::ImageURL
  include Phlex::Rails::Helpers::Routes

  def initialize(title: "Tribely")
    @title = title
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

        og_image = image_url("og-image.png")
        site_url = root_url

        meta property: "og:type", content: "website"
        meta property: "og:url", content: site_url
        meta property: "og:title", content: @title
        meta property: "og:description", content: "Streamline your workflow with our intuitive project management tool. Manage projects, track stories, and collaborate with your team effortlessly."
        meta property: "og:image", content: og_image
        meta property: "og:image:width", content: "1200"
        meta property: "og:image:height", content: "628"

        meta name: "twitter:card", content: "summary_large_image"
        meta name: "twitter:url", content: site_url
        meta name: "twitter:title", content: @title
        meta name: "twitter:description", content: "Streamline your workflow with our intuitive project management tool. Manage projects, track stories, and collaborate with your team effortlessly."
        meta name: "twitter:image", content: og_image

        csrf_meta_tags
        csp_meta_tag
        content_for :head

        render Components::Shared::Favicon.new
        # Google Fonts
        link rel: "preconnect", href: "https://fonts.googleapis.com"
        link rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous"
        link href: "https://fonts.googleapis.com/css2?family=Cascadia+Mono:wght@400;700&display=swap", rel: "stylesheet"

        stylesheet_link_tag :app, "data-turbo-track": "reload"
        javascript_importmap_tags
      end

      body(class: "bg-base text-text font-sans") do
        render Components::LandingPage::Header.new
        render Components::Shared::FlashMessages.new

        main(class: "pt-32") do
          yield
        end

        render Components::LandingPage::Footer.new
        render Components::Shared::CookieConsent.new
      end
    end
  end
end
