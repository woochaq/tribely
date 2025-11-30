class Integrations::Slack < Integration
  store_accessor :settings, :webhook_url

  validates :webhook_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }

  def self.model_name
    ActiveModel::Name.new(self, nil, "Integration")
  end

  def test_connection
    uri = URI.parse(webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = { text: "🎉 *Test notification from Tribely!*" }.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      raise RuntimeError, "Slack API error: #{response.code} - #{response.body}"
    end
    true
  rescue URI::InvalidURIError
    raise RuntimeError, "Invalid Slack Webhook URL"
  rescue Errno::ECONNREFUSED
    raise RuntimeError, "Network error: Connection refused"
  rescue StandardError => e
    raise RuntimeError, "Network error: #{e.message}"
  end
end
