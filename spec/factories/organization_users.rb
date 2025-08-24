FactoryBot.define do
  factory :organization_user do
    user { FactoryBot.create(:user) }
    organization { FactoryBot.create(:organization) }
    role { 0 }
  end
end
