class ProcessWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook, payload)
    webhook.touch(:last_triggered_at)
    WebhookService.new(webhook, payload).process
  end
end
