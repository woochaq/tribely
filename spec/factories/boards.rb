FactoryBot.define do
  factory :board do
    kind { :current }
    project { FactoryBot.create(:project) }
  end
end
