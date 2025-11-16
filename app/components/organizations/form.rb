class Components::Organizations::Form < Components::Base
  include Phlex::Rails::Helpers::ImageTag
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::LinkTo
  include SimpleForm::ActionViewExtensions::FormHelper

  def initialize(organization:)
    @organization = organization
  end

  def view_template
    div(class: "mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-lg") do
      simple_form_for(@organization) do |f|
        div(class: "space-y-6") do
          div(class: "space-y-6") do
            div(
              class: "flex flex-col items-center space-y-4",
              data: { controller: "avatar-preview" }
            ) do
              label(
                for: "organization_avatar",
                class: "relative cursor-pointer group"
              ) do
                if @organization.avatar.attached? && @organization.avatar.persisted?
                  image_tag(@organization.avatar.variant(:thumb), class: "h-32 w-32 rounded-full object-cover border-4 border-surface2", data: { "avatar-preview-target": "preview" })
                else
                  img(
                    src: "https://placehold.co/128x128/24273a/7480c2?text=avatar",
                    class: "h-32 w-32 rounded-full object-cover border-4 border-surface2",
                    data: { "avatar-preview-target": "preview" }
                  )
                end

                div(class: "absolute inset-0 bg-black/50 rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity") do
                  svg(class: "w-8 h-8 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do |s|
                    s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z")
                    s.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M15 13a3 3 0 11-6 0 3 3 0 016 0z")
                  end
                end
              end
              f.input :avatar, as: :file, label: false, wrapper: false,
                input_html: {
                  id: "organization_avatar",
                  class: "hidden",
                  accept: "image/png, image/jpeg, image/webp, image/avif, image/svg+xml",
                  data: {
                    "avatar-preview-target": "input",
                    action: "change->avatar-preview#updatePreview"
                  }
                }
            end
          end

          f.input :name, autofocus: true

          div(class: "flex items-center justify-end gap-4 pt-4 border-t border-crust mt-6") do
            link_to "Cancel", organizations_path, class: "btn-secondary"
            f.button :submit, "Update Organization", class: "btn-primary"
          end
        end
      end
    end
  end
end
