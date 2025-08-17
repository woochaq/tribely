class Components::Layout < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::JavaScriptImportmapTags
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::ContentFor

  def initialize(title: "Tribely")
    @title = title
  end

  def view_template(&block)
    doctype

    html(class: "h-full bg-base") do
      head do
        title { @title }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        meta name: "apple-mobile-web-app-capable", content: "yes"
        meta name: "mobile-web-app-capable", content: "yes"
        csrf_meta_tags
        csp_meta_tag
        content_for :head
        link rel: "icon", href: "/icon.png", type: "image/png"
        link rel: "icon", href: "/icon.svg", type: "image/svg+xml"
        link rel: "apple-touch-icon", href: "/icon.png"

        # link rel: "manifest", href: pwa_manifest_path(format: :json)

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
      end
    end
  end
end
