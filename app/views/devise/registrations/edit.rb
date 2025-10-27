class Views::Devise::Registrations::Edit < Views::App::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers
  include Phlex::Rails::Helpers::ImageTag

  def initialize(minimum_password_length:, resource:, resource_name:)
    @minimum_password_length = minimum_password_length
    @resource = resource
    @resource_name = resource_name
  end

  def page_title
    "Account #{@resourceemail}"
  end


  def view_template
    section(id: "edit-#{@resource_name}", class: "py-10 md:py-18") do
      div(class: "container mx-auto") do
        div(class: "max-w-3xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-2xl shadow-crust/20") do
          h2(class: "text-2xl font-bold text-center text-text mb-6") { "Welcome #{@resource.email}" }
          simple_form_for(@resource, as: @resource_name, url: registration_path(@resource_name), html: { method: :put }) do |f|
            div(class: "space-y-6") do
              div(
                class: "flex flex-col items-center space-y-4",
                data: { controller: "avatar-preview" }
              ) do
                label(
                  for: "user_avatar",
                  class: "relative cursor-pointer group"
                ) do
                  if @resource.avatar.attached? && @resource.avatar.persisted?
                    image_tag(@resource.avatar.variant(:thumb), class: "h-32 w-32 rounded-full object-cover border-4 border-surface2", data: { "avatar-preview-target": "preview" })
                  else
                    img(
                      src: "https://placehold.co/128x128/24273a/7480c2?text=Avatar",
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

                f.input :avatar,
                  as: :file,
                  input_html: {
                    id: "user_avatar",
                    class: "hidden",
                    accept: "image/png, image/jpeg, image/webp, image/avif, image/svg+xml",
                    data: {
                      "avatar-preview-target": "input",
                      action: "change->avatar-preview#updatePreview"
                    }
                  },
                  label: false,
                  wrapper: false
              end

              f.input :full_name
              f.input :email, disabled: true
              if view_context.devise_mapping.confirmable? && @resource.pending_reconfirmation?
                div { plain "Currently waiting confirmation for: #{@resource.unconfirmed_email}" }
              end
              hr
              f.input :password, hint: "Leave blank if you don't want to change it", input_html: { autocomplete: "new-password" }
              f.input :password_confirmation, input_html: { autocomplete: "new-password" }
              f.input :current_password, input_html: { autocomplete: "current-password" }
              f.button :submit, "Save", class: "btn-primary w-full"
            end
          end
          div(class: "my-10") { "If you want to cancel your account, you can do so below." }
          div do
            a(href: registration_path(@resource_name), data: { turbo_method: :delete, confirm: "Are you sure?", turbo_confirm: "Are you sure?" }, class: "btn-warn") { "Cancel my account" }
          end
        end
      end
    end
  end
end
