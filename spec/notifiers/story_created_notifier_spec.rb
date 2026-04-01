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

  describe "slack delivery" do
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

  describe "discord delivery" do
    let!(:discord_integration) { create(:discord_integration, project: project, events: [ "story_created" ], active: true) }

    before do
      stub_request(:post, discord_integration.webhook_url).to_return(status: 204)
    end

    context "when active discord integration exists with story_created event" do
      it "delivers to discord" do
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, author: owner).deliver
          end
        }.not_to raise_error

        expect(WebMock).to have_requested(:post, discord_integration.webhook_url).twice
          .with { |req|
            body = JSON.parse(req.body)
            embed = body["embeds"]&.first
            embed.present? &&
            embed["title"].include?("New Story Created") &&
            embed["description"].include?(story.title)
          }
      end
    end

    context "when inactive discord integration exists" do
      it "does not deliver to discord" do
        discord_integration.update(active: false)
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, author: owner).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, discord_integration.webhook_url)
      end
    end

    context "when active discord integration exists without story_created event" do
      it "does not deliver to discord" do
        discord_integration.update(events: [])
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, author: owner).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, discord_integration.webhook_url)
      end
    end
  end
end
