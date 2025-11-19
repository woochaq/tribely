FactoryBot.define do
  factory :webhook do
    association :project
    association :board
    association :created_by, factory: :user
    name { "Test Webhook" }
    active { true }
    webhook_type { :create_story }

    before(:create) do |webhook|
      # Ensure board belongs to project
      webhook.board.update(project: webhook.project)

      # Ensure creator is in organization and is project owner
      unless webhook.project.organization.users.exists?(webhook.created_by.id)
        create(:organization_user, organization: webhook.project.organization, user: webhook.created_by, role: :owner)
      end

      unless webhook.project.project_users.exists?(user: webhook.created_by, role: :owner)
        create(:project_user, project: webhook.project, user: webhook.created_by, role: :owner)
      end
    end
  end
end
