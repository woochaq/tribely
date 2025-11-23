require 'rails_helper'

RSpec.describe ProcessWebhookJob, type: :job do
  let(:webhook) { create(:webhook) }
  let(:payload) { { "title" => "Test Story" } }

  it 'queues the job' do
    expect {
      ProcessWebhookJob.perform_later(webhook, payload)
    }.to have_enqueued_job(ProcessWebhookJob)
      .on_queue("default")
  end

  it 'calls WebhookService and updates last_triggered_at' do
    service_instance = instance_double(WebhookService)
    allow(WebhookService).to receive(:new).and_return(service_instance)
    expect(service_instance).to receive(:process)

    perform_enqueued_jobs do
      ProcessWebhookJob.perform_later(webhook, payload)
    end

    expect(webhook.reload.last_triggered_at).to be_present
  end
end
