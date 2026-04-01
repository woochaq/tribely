require "rails_helper"
require "webmock/rspec"

RSpec.describe AssignedToStoryNotifier, type: :notifier do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:assigner) { create(:user) }
  let(:assigned_user) { create(:user) }
  let!(:slack_integration) { create(:slack_integration, project: project, events: [ 'story_assigned' ], active: true) }

  before do
    stub_request(:post, slack_integration.webhook_url).to_return(status: 200, body: "ok")
    create(:organization_user, organization: organization, user: assigner, role: :member)
    create(:project_user, project: project, user: assigner, role: :owner)
    create(:organization_user, organization: organization, user: assigned_user, role: :member)
    create(:project_user, project: project, user: assigned_user, role: :member)
  end

  let(:story) { create(:story, project: project, board: board, owner: assigner, user: assigned_user) }

  describe "slack delivery" do
    context "when active slack integration exists with story_assigned event" do
      it "delivers to slack" do
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error

        expect(WebMock).to have_requested(:post, slack_integration.webhook_url)
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

            text_blocks.any? { |t| t.include?("Story Assigned") } &&
            text_blocks.any? { |t| t.include?(story.title) } &&
            text_blocks.any? { |t| t.include?(assigned_user.name) }
          }
      end
    end

    context "when inactive slack integration exists with story_assigned event" do
      it "does not deliver to slack" do
        slack_integration.update(active: false)
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, slack_integration.webhook_url)
      end
    end

    context "when active slack integration exists without story_assigned event" do
      it "does not deliver to slack" do
        slack_integration.update(active: true, events: [])
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, slack_integration.webhook_url)
      end
    end
  end

  describe "discord delivery" do
    let!(:discord_integration) { create(:discord_integration, project: project, events: [ "story_assigned" ], active: true) }

    before do
      stub_request(:post, discord_integration.webhook_url).to_return(status: 204)
    end

    context "when active discord integration exists with story_assigned event" do
      it "delivers to discord" do
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error

        expect(WebMock).to have_requested(:post, discord_integration.webhook_url)
          .with { |req|
            body = JSON.parse(req.body)
            embed = body["embeds"]&.first
            embed.present? &&
            embed["title"].include?("Story Assigned") &&
            embed["description"].include?(assigned_user.name)
          }
      end
    end

    context "when inactive discord integration exists" do
      it "does not deliver to discord" do
        discord_integration.update(active: false)
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, discord_integration.webhook_url)
      end
    end

    context "when active discord integration exists without story_assigned event" do
      it "does not deliver to discord" do
        discord_integration.update(events: [])
        expect {
          perform_enqueued_jobs do
            described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, discord_integration.webhook_url)
      end
    end
  end

  describe "email delivery" do
    it "delivers email to assigned user" do
      expect {
        perform_enqueued_jobs do
          described_class.with(story: story, assigner: assigner, assigned_user: assigned_user).deliver
        end
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
