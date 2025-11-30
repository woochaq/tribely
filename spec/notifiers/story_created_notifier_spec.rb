require "rails_helper"

RSpec.describe StoryCreatedNotifier, type: :notifier do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:owner) { create(:user) }
  let(:slack_integration) { create(:slack_integration, project: project, events: [ "story_created" ]) }

  before do
    stub_request(:post, slack_integration.webhook_url).to_return(status: 200, body: "ok")
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:project_user, project: project, user: owner, role: :owner)
  end

  let(:story) { create(:story, board: project.boards.first, owner: owner) }

  describe "delivery" do
    it "delivers to slack" do
      expect {
        perform_enqueued_jobs do
          described_class.with(story: story, author: owner).deliver
        end
      }.not_to raise_error

      expect(WebMock).to have_requested(:post, slack_integration.webhook_url).twice
        .with { |req|
          body = JSON.parse(req.body)
          text_blocks = body["blocks"].flat_map do |b|
            if b["type"] == "section"
              [ b.dig("text", "text") ]
            elsif b["type"] == "context"
              b["elements"].map { |e| e["text"] }
            else
              []
            end
          end.compact

          text_blocks.any? { |t| t.include?("New Story Created") }
        }
    end
  end
end
