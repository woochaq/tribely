FactoryBot.define do
  factory :story do
    association :board
    owner { create(:user) }
    user { nil }
    title { "My first story" }
    description { "Story description" }
    status { 0 }
    story_type { 0 }
  end
end
