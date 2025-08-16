
class Views::Devise::Passwords::New < Views::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers


  def initialize(resource:, resource_name:)
    @resource = resource
    @resource_name = resource_name
  end

  def page_title
    "Forgot your password"
  end


  def view_template
    section(id: "log-in", class: "py-10 md:py-18") do
      div(class: "container mx-auto") do
        div(class: "max-w-3xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-2xl shadow-crust/20") do
          h2(class: "text-2xl font-bold text-center text-text mb-6") { "Forgot your password?" }
          simple_form_for(@resource, as: @resource_name, url: password_path(@resource_name), html: { method: :post }) do |f|
            div(class: "space-y-6") do
              f.input :email, autofocus: true, autocomplete: "email"
              f.button :submit, "Send me reset password instructions", class: "btn-primary w-full"
            end
          end
          render Components::Devise::Shared::Links.new(devise_mapping: view_context.devise_mapping, resource_class: @resource.class, resource_name: @resource_name)
        end
      end
    end
  end
end
