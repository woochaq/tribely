FactoryBot.define do
  factory :invitation do
    organization { nil }
    sender { nil }
    recipient { nil }
    sequence(:email) { |n| "test_user_#{n}@example.com" }
    status { :pending }
  end
end
