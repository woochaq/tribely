FactoryBot.define do
  factory :user do
    full_name { "John Doe" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.current }
  end
end
