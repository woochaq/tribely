class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]

  before_action :configure_account_update_params, only: [ :update ]

  def new
    redirect_to root_path, alert: "You shall not pass! 🧙‍♂️" and return
    build_resource(sign_up_params)
    yield resource if block_given?
    render Views::Devise::Registrations::New.new(minimum_password_length: @minimum_password_length, resource: resource, resource_name: resource_name)
  end

  def create
    redirect_to root_path and return
    build_resource(sign_up_params)

    resource.save

    yield resource if block_given?

    if resource.persisted?
      if session[:invitation_token]
        invitation = Invitation.find_by(token: session[:invitation_token])
        if invitation
          AcceptInvitation.call(invitation: invitation, user: resource)
          session.delete(:invitation_token)
        end
      end

      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      render Views::Devise::Registrations::New.new(minimum_password_length: @minimum_password_length, resource: resource, resource_name: resource_name), status: :unprocessable_content
    end
  end

  def edit
    render Views::Devise::Registrations::Edit.new(minimum_password_length: @minimum_password_length, resource: resource, resource_name: resource_name)
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?


      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      render Views::Devise::Registrations::Edit.new(minimum_password_length: @minimum_password_length, resource: resource, resource_name: resource_name), status: :unprocessable_content
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :full_name ])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  def update_resource(resource, params)
    # Require current password if password or password_confirmation are present
    if params[:password].present? || params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params.except(:current_password))
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
