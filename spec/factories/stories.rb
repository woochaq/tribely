FactoryBot.define do
  factory :story do
    association :board
    owner { create(:user) }
    association :user
    title { "My first story" }
    description { "Story description" }
    status { 0 }
    story_type { 0 }
  end
end
