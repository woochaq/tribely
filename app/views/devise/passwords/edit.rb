class Views::Devise::Passwords::Edit < Views::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers

  def initialize(minimum_password_length:, resource:, resource_name:)
    @minimum_password_length = minimum_password_length
    @resource = resource
    @resource_name = resource_name
  end

  def page_title
    "Change your password"
  end

  def view_template
    section(id: "change-password", class: "py-10 md:py-18") do
      div(class: "container mx-auto") do
        div(class: "max-w-3xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-2xl shadow-crust/20") do
          h2(class: "text-2xl font-bold text-center text-text mb-6") { "Change your password" }
          simple_form_for(@resource, as: @resource_name, url: password_path(@resource_name), html: { method: :put }) do |f|
            div(class: "space-y-6") do
              f.input :reset_password_token, as: :hidden
              if @resource.errors.any?
                div(class: "text-danger") do
                  @resource.errors.full_messages.each do |message|
                    div(class: "error-message") { message }
                  end
                end
              end
              f.input :password, autofocus: true, autocomplete: "new-password", hint: "Minimum #{@minimum_password_length} characters"
              f.input :password_confirmation, autocomplete: "new-password"
              f.button :submit, "Change my password", class: "btn-primary w-full"
            end
          end

          render Components::Devise::Shared::Links.new(devise_mapping: view_context.devise_mapping, resource_class: @resource.class, resource_name: @resource_name)
        end
      end
    end
  end
end
