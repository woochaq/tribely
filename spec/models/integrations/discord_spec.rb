require "rails_helper"
require "webmock/rspec"

RSpec.describe Integrations::Discord, type: :model do
  include WebMock::API

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  after do
    WebMock.allow_net_connect!
  end

  describe "validations" do
    it "validates presence of webhook_url" do
      integration = build(:discord_integration, settings: { webhook_url: nil })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("can't be blank")
    end

    it "validates format of webhook_url" do
      integration = build(:discord_integration, settings: { webhook_url: "invalid-url" })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("must be a valid URL")

      integration.webhook_url = "https://discord.com/api/webhooks/123/abc"
      expect(integration).to be_valid
    end
  end

  describe "#test_connection" do
    let(:integration) { create(:discord_integration) }
    let(:valid_webhook_url) { integration.webhook_url }

    context "when connection is successful" do
      before do
        stub_request(:post, valid_webhook_url)
          .with(
            body: {
              embeds: [
                {
                  title: "Test Notification",
                  description: "🎉 **Test notification from Tribely!** This is a test message to verify your integration configuration.",
                  color: 5793266
                }
              ]
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
          .to_return(status: 204)
      end

      it "returns true" do
        expect(integration.test_connection).to be true
      end
    end

    context "when Discord API returns an error" do
      before do
        stub_request(:post, valid_webhook_url).to_return(status: 400, body: "Bad Request")
      end

      it "raises a Discord API error" do
        expect { integration.test_connection }.to raise_error(
          RuntimeError,
          "Network error: Discord API error: 400 - Bad Request"
        )
      end
    end

    context "when there is a network error" do
      before do
        stub_request(:post, valid_webhook_url).to_raise(Errno::ECONNREFUSED.new("Connection refused"))
      end

      it "raises a network error" do
        expect { integration.test_connection }.to raise_error(
          RuntimeError,
          "Network error: Connection refused"
        )
      end
    end

    context "when the URL is invalid" do
      let(:integration) { build(:discord_integration, settings: { webhook_url: "not a url at all %" }) }

      before do
        allow(URI).to receive(:parse).and_raise(URI::InvalidURIError)
      end

      it "raises a RuntimeError with invalid URL message" do
        expect { integration.test_connection }.to raise_error(RuntimeError, "Invalid Discord Webhook URL")
      end
    end
  end
end
