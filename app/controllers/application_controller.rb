class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, unless: -> {  devise_controller? || mission_control_controller? }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout false

  before_action :configure_permitted_params, if: :devise_controller?


  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :avatar ])
  end

  def mission_control_controller?
    is_a?(::MissionControl::Jobs::ApplicationController)
  end
end
