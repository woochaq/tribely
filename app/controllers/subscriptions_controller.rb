class SubscriptionsController < ApplicationController
  def new
    @email_subscription = EmailSubscription.new
    authorize @email_subscription
    render Views::Subscriptions::New.new(email_subscription: @email_subscription)
  end

  def create
    @email_subscription = EmailSubscription.new(email_subscription_params)

    authorize @email_subscription
    if @email_subscription.valid?
      @email_subscription.save
      redirect_to new_subscription_path, notice: "Thank you for subscribing! We'll keep you updated on our progress."
    else
      render Views::Subscriptions::New.new(email_subscription: @email_subscription), status: :unprocessable_entity
    end
  end

  private

  def email_subscription_params
    params.require(:email_subscription).permit(:email)
  end
end
