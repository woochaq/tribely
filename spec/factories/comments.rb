FactoryBot.define do
  factory :comment do
    story { create(:story) }
    user { create(:user) }
    content { "comment content" }
  end
end
