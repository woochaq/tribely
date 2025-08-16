class Views::Devise::Sessions::New < Views::Base
  include Phlex::Rails::Helpers::FormFor
  include SimpleForm::ActionViewExtensions::FormHelper
  include ::Devise::Controllers::UrlHelpers

  def initialize(resource:, devise_mapping:, resource_name:)
    @resource = resource
    @devise_mapping = devise_mapping
    @resource_name = resource_name
  end

  def page_title
    "Log in"
  end

  def view_template
    section(id: "log-in", class: "py-10 md:py-18") do
      div(class: "container mx-auto") do
        div(class: "max-w-3xl mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-2xl shadow-crust/20") do
          h2(class: "text-2xl font-bold text-center text-text mb-6") { "Log in to Tribely" }
          simple_form_for(@resource, as: @resource_name, url: session_path(@resource_name)) do |f|
            div(class: "space-y-6") do
              f.input :email, autofocus: true, input_html: { autocomplete: "email" }
              f.input :password, input_html: { autocomplete: "current-password" }

              if @devise_mapping.rememberable?
                div(class: "flex items-center") do
                  f.check_box :remember_me, class: "h-4 w-4 rounded border-crust text-mauve focus:ring-mauve cursor-pointer"
                  f.label :remember_me, class: "ml-2 block cursor-pointer"
                end
              end

              f.button :submit, "Log in", class: "btn-primary w-full"
            end
          end

          render Components::Devise::Shared::Links.new(devise_mapping: @devise_mapping, resource_class: @resource.class, resource_name: @resource_name)
        end
      end
    end
  end
end
