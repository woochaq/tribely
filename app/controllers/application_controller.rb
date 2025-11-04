class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, unless: -> {  devise_controller? || mission_control_controller? }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout false

  before_action :configure_permitted_params, if: :devise_controller?

  private

  def user_not_authorized(exception)
    message = "You are not authorized to perform this action."

    respond_to do |format|
      format.html do
        flash[:alert] = message
        redirect_to(request.referrer || projects_path)
      end
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("modal", ""),
          turbo_stream.append("flash-container", Components::Shared::Toast.new(type: :alert, message: message))
        ], status: :forbidden
      end
    end
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :avatar ])
  end

  def mission_control_controller?
    is_a?(::MissionControl::Jobs::ApplicationController)
  end
end
