FactoryBot.define do
  factory :integration do
    association :project
    association :created_by, factory: :user
    name { "My Integration" }
    active { true }
    events { [] }

    factory :slack_integration, class: "Integrations::Slack" do
      type { "Integrations::Slack" }
      name { "My Slack" }
      settings { { webhook_url: "https://hooks.slack.com/services/T000/B000/XXX" } }
    end
  end
end
