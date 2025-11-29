module Integrations
  class Slack < Integration
    store_accessor :settings, :webhook_url

    validates :webhook_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }

    def self.model_name
      ActiveModel::Name.new(self, nil, "Integration")
    end

    def test_notifier_class
      Integrations::Slack::TestNotifier
    end
  end
end
