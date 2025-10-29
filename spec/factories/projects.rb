FactoryBot.define do
  factory :project do
    association :organization
    name { "MyString" }
    prefix { "MyString" }
  end
end
