FactoryBot.define do
  factory :board do
    kind { :current }
    project { create(:project) }
  end
end
