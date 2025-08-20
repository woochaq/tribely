class Components::AppLayout < Components::Base
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag
  include Phlex::Rails::Helpers::JavaScriptImportmapTags
  include Phlex::Rails::Helpers::StylesheetLinkTag

  def initialize(title: "Tribely App")
    @title = title
  end

  def view_template(&block)
    doctype

    html(class: "h-full bg-base") do
      head do
        title { @title }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        csrf_meta_tags
        csp_meta_tag

        # Google Fonts
        link rel: "preconnect", href: "https://fonts.googleapis.com"
        link rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous"
        link href: "https://fonts.googleapis.com/css2?family=Cascadia+Mono:wght@400;700&display=swap", rel: "stylesheet"

        stylesheet_link_tag :app, "data-turbo-track": "reload"
        javascript_importmap_tags
      end

      body(class: "h-full font-sans text-text") do
        render Components::Shared::FlashMessages.new

        div(class: "flex flex-col h-full") do
          render Components::App::Header.new

          div(class: "flex flex-1 overflow-hidden") do
            render Components::App::Sidebar.new

            # The main content will be rendered here
            main(class: "flex-1 flex flex-col p-4 sm:p-6 lg:p-8 overflow-hidden") do
              yield_content(&block)
            end
          end
        end
      end
    end
  end

  private

  def yield_content(&block)
    main(class: "flex-1 overflow-y-auto", &block)
  end
end
