class Views::Devise::Registrations::Edit < Views::App::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers

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
              f.input :full_name
              f.input :email, disabled: true
              if view_context.devise_mapping.confirmable? && @resource.pending_reconfirmation?
                div { plain "Currently waiting confirmation for: #{@resource.unconfirmed_email}" }
              end
              hr
              f.input :password, autocomplete: "new-password", hint: "Leave blank if you don't want to change it"
              f.input :password_confirmation, autocomplete: "new-password"
              f.input :current_password, autocomplete: "current-password"
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
