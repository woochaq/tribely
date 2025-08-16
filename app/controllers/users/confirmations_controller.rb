# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    self.resource = resource_class.new
    render Views::Devise::Confirmations::New.new(resource: resource, resource_name: resource_name)
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      render Views::Devise::Confirmations::New.new(resource: resource, resource_name: resource_name), status: :unprocessable_content
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      render Views::Devise::Confirmations::New.new(resource: resource, resource_name: resource_name), status: :unprocessable_content
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
