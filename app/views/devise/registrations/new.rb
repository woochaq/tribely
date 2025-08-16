class Views::Devise::Registrations::New < Views::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers

  def page_title
    "Sign up"
  end

  def initialize(minimum_password_length:, resource:, resource_name:)
    @minimum_password_length = minimum_password_length
    @resource = resource
    @resource_name = resource_name
  end

  def view_template
    section(id: "log-in", class: "py-10 md:py-18") do
      div(class: "container mx-auto") do
        div(class: "max-w-3xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-2xl shadow-crust/20") do
          h2(class: "text-2xl font-bold text-center text-text mb-6") { "Sign in to Tribely" }
          simple_form_for(@resource, as: @resource_name, url: registration_path(@resource_name)) do |f|
            div(class: "space-y-6") do
              f.input :email, autofocus: true, autocomplete: "email"
              f.input :password, autocomplete: "new-password", hint: "Minimum #{@minimum_password_length} characters"
              f.input :password_confirmation, autocomplete: "new-password"
              f.button :submit, "Sign in", class: "btn-primary w-full"
            end
          end
          render Components::Devise::Shared::Links.new(devise_mapping: view_context.devise_mapping, resource_class: @resource.class, resource_name: @resource_name)
        end
      end
    end
  end
end
