class Components::Devise::Shared::Links < Components::Base
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include ::Devise::Controllers::UrlHelpers

  attr_accessor :resource_class, :resource_name

  def initialize(devise_mapping:, resource_class:, resource_name:)
    @devise_mapping = devise_mapping
    @resource_class = resource_class
    @resource_name = resource_name
  end

  def view_template
    div(class: "mt-5 text-center text-sm") do
      if controller_name != "sessions"
        div { link_to "Log in", new_session_path(resource_name) }
      end

      if @devise_mapping.registerable? && controller_name != "registrations"
        div { link_to "Sign up", new_registration_path(resource_name) }
      end

      if @devise_mapping.recoverable? && controller_name != "passwords" &&
          controller_name != "registrations"
        div { link_to "Forgot your password?", new_password_path(resource_name) }
      end

      if @devise_mapping.confirmable? && controller_name != "confirmations"
        div { link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) }
      end

      if @devise_mapping.lockable? && @resource_class.unlock_strategy_enabled?(:email) && controller_name != "unlocks"
        div { link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) }
      end

      if @devise_mapping.omniauthable?
        resource_class.omniauth_providers.each do |provider|
          button_to "Sign in with #{OmniAuth::Utils.camelize(provider)}", omniauth_authorize_path(resource_name, provider), data: { turbo: false }
        end
      end
    end
  end
end
