require 'rails_helper'

RSpec.describe "Api::Webhooks", type: :request do
  let(:webhook) { create(:webhook, active: true) }
  let(:inactive_webhook) { create(:webhook, active: false) }
  let(:valid_payload) { { title: "New Story", description: "Created via API" } }

  describe "POST /api/webhooks/:token" do
    context "with a valid and active token" do
      it "returns http ok" do
        post api_webhook_path(webhook.token), params: valid_payload
        expect(response).to have_http_status(:ok)
      end

      it "enqueues a ProcessWebhookJob" do
        expect {
          post api_webhook_path(webhook.token), params: valid_payload
        }.to have_enqueued_job(ProcessWebhookJob).with(webhook, hash_including("title" => "New Story"))
      end
    end

    context "with an inactive token" do
      it "returns http not_found" do
        post api_webhook_path(inactive_webhook.token), params: valid_payload
        expect(response).to have_http_status(:not_found)
      end

      it "does not enqueue a job" do
        expect {
          post api_webhook_path(inactive_webhook.token), params: valid_payload
        }.not_to have_enqueued_job(ProcessWebhookJob)
      end
    end

    context "with an invalid token" do
      it "returns http not_found" do
        post api_webhook_path("invalid_token"), params: valid_payload
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
