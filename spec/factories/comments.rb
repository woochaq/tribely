FactoryBot.define do
  factory :comment do
    story { FactoryBot.create(:stroy) }
    user { FactoryBot.create(:user) }
  end
end
