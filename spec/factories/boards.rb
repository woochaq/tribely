FactoryBot.define do
  factory :board do
    name { "MyString" }
    project { FactoryBot.create(:project) }
  end
end
