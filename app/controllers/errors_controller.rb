class ErrorsController < ActionController::Base
  def not_found
    if current_user.present?
      render Views::Errors::LoggedNotFound.new, status: :not_found
    else
      render Views::Errors::NotLoggedNotFound.new, status: :not_found
    end
  end

  def internal_server_error
    Honeybadger.notify(request.env["action_dispatch.exception"])
    if current_user.present?
      render Views::Errors::LoggedInternalServerError.new, status: :not_found
    else
      render Views::Errors::NotLoggedInternalServerError.new, status: :not_found
    end
  end
end
