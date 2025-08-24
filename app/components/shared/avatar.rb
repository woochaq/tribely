class Components::Shared::Avatar < Components::Base
  include Phlex::Rails::Helpers::ClassNames

  def initialize(user:, url: nil, size: "h-10 w-10", bg: "bg-info", font_color: "text-crust", font_size: "text-lg")
    @user = user
    @url = url
    @attributes = { size: size, bg: bg, font_color: font_color, font_size: font_size }
  end

  def view_template
    base_class = "flex items-center justify-center rounded-full font-bold"
    if @url.present?
      a(href: @url, class: class_names(base_class, @attributes.values.join(" ")), title: "Edit profile") do
        span { @user.initials }
      end
    else
      div(class: class_names(base_class, @attributes.values.join(" "))) { @user.initials }
    end
  end
end
