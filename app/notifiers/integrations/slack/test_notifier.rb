class Integrations::Slack::TestNotifier < ApplicationNotifier
  deliver_by :slack do |config|
    config.url = -> { params[:integration].webhook_url }
    config.json = -> {
      {
        blocks: [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "🎉 *Test notification from Tribely!* This is a test message to verify your integration configuration."
            }
          }
        ]
      }
    }
  end

  required_param :integration
end
