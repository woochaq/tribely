FactoryBot.define do
  factory :comment do
    story { FactoryBot.create(:story) }
    user { FactoryBot.create(:user) }
    content { "comment content" }
  end
end
