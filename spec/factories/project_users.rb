FactoryBot.define do
  factory :project_user do
    project { nil }
    user { nil }
    role { 0 } # owner
  end
end
