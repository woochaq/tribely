require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Integrations::Slack, type: :model do
  include WebMock::API

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  after do
    WebMock.allow_net_connect!
  end

  describe 'validations' do
    it "validates presence of webhook_url" do
      integration = build(:slack_integration, settings: { webhook_url: nil })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("can't be blank")
    end

    it "validates format of webhook_url" do
      integration = build(:slack_integration, settings: { webhook_url: "invalid" })
      expect(integration).not_to be_valid
      expect(integration.errors[:webhook_url]).to include("must be a valid URL")
    end
  end

  describe '#test_connection' do
    let(:integration) { create(:slack_integration) }
    let(:valid_webhook_url) { integration.webhook_url }
    let(:invalid_webhook_url) { "http://invalid.slack.com/webhook" }

    context 'when connection is successful' do
      before do
        stub_request(:post, valid_webhook_url).to_return(status: 200, body: "ok")
      end

      it 'returns true' do
        expect(integration.test_connection).to be true
      end
    end

    context 'when Slack API returns an error' do
      before do
        stub_request(:post, valid_webhook_url).to_return(status: 400, body: "invalid_payload")
      end

      it 'raises a Slack API error' do
        expect { integration.test_connection }.to raise_error(
          RuntimeError,
          "Network error: Slack API error: 400 - invalid_payload"
        )
      end
    end

    context 'when there is a network error' do
      before do
        stub_request(:post, valid_webhook_url).to_raise(Errno::ECONNREFUSED.new("Connection refused"))
      end

      it 'raises a network error' do
        expect { integration.test_connection }.to raise_error(
          RuntimeError,
          "Network error: Connection refused"
        )
      end
    end
  end
end
