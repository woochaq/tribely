# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    render Views::Devise::Sessions::New.new(resource: self.resource, devise_mapping: devise_mapping, resource_name: resource_name)
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    if session[:invitation_token]
      invitation = Invitation.find_by(token: session.delete(:invitation_token))
      if invitation
        AcceptInvitation.call(invitation: invitation, user: resource)
        return organization_path(invitation.organization)
      end
    end

    stored_location_for(resource) || projects_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
