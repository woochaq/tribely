class Components::Shared::Avatar < Components::Base
  include Phlex::Rails::Helpers::ClassNames
  include Phlex::Rails::Helpers::URLFor

  def initialize(user:, url: nil, size: "h-10 w-10", bg: "bg-info", font_color: "text-crust", font_size: "text-lg")
    @user = user
    @url = url
    @attributes = { size: size, bg: bg, font_color: font_color, font_size: font_size }
  end

  def view_template
    base_class = "flex items-center justify-center rounded-full font-bold"

    tag = @url.present? ? :a : :div
    options = {
      class: class_names(base_class, @attributes.values_at(:size, :bg)),
      title: @url.present? ? "Edit profile" : @user&.full_name
    }
    options[:href] = @url if @url.present?

    send(tag, **options) do
      if @user&.avatar&.attached?
        img(
          src: url_for(@user.avatar.variant(resize_to_fill: [ 40, 40 ])),
          class: "rounded-full object-cover h-full w-full border-2 border-crust"
        )
      else
        span(class: class_names(@attributes.values_at(:font_color, :font_size))) do
          @user&.initials || "-"
        end
      end
    end
  end
end
