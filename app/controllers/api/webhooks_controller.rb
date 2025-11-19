module Api
  class WebhooksController < ActionController::API
    def create
      webhook = Webhook.active.find_by_token(params[:token])

      if webhook
        ProcessWebhookJob.perform_later(webhook, request.request_parameters)
        head :ok
      else
        head :not_found
      end
    end
  end
end
