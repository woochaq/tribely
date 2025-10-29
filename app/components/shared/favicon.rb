class Components::Shared::Favicon < Components::Base
  include Phlex::Rails::Helpers::AssetPath

  def view_template
    link(
      rel: "icon",
      type: "image/png",
      href: "/favicon/favicon-96x96.png",
      sizes: "96x96"
    )

    link(
      rel: "icon",
      type: "image/svg+xml",
      href: "/favicon/favicon.svg"
    )

    link(rel: "shortcut icon", href: "favicon/favicon.ico")

    link(
      rel: "apple-touch-icon",
      sizes: "180x180",
      href: "/favicon/apple-touch-icon.png"
    )

    meta(name: "apple-mobile-web-app-title", content: "Tribel")

    link rel: "manifest", href: pwa_manifest_path(format: :json)
  end
end
