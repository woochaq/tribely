FactoryBot.define do
  factory :document do
    project { FactoryBot.create(:project) }
    title { "MyString" }
    content { "Wysywig content" }
    created_by { nil }
    last_updated_by { nil }
  end
end
