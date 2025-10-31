FactoryBot.define do
  factory :organization_user do
    user { create(:user) }
    organization { create(:organization) }
    role { 0 } # owner
  end
end
