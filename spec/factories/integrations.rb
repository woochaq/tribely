FactoryBot.define do
  factory :integration do
    association :project
    association :created_by, factory: :user
    name { "My Integration" }
    type { "Integrations::Slack" } # Default to Slack for base integration
    active { true }
    events { [] }

    factory :slack_integration, class: "Integrations::Slack" do
      type { "Integrations::Slack" }
      name { "My Slack" }
      settings { { webhook_url: "https://hooks.slack.com/services/T000/B000/XXX" } }
    end

    factory :discord_integration, class: "Integrations::Discord" do
      type { "Integrations::Discord" }
      name { "My Discord" }
      settings { { webhook_url: "https://discord.com/api/webhooks/123/abc" } }
    end
  end
end
