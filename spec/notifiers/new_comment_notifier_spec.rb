require "rails_helper"
require "webmock/rspec"

RSpec.describe NewCommentNotifier, type: :notifier do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { project.boards.first }
  let(:story_owner) { create(:user) }
  let(:story_user) { create(:user) }
  let(:commenter) { create(:user) }
  let!(:slack_integration) { create(:slack_integration, project: project, events: [ 'comment_created' ], active: true) }

  before do
    stub_request(:post, slack_integration.webhook_url).to_return(status: 200, body: "ok")
    [ story_owner, story_user, commenter ].each do |user|
      create(:organization_user, organization: organization, user: user, role: :member)
      create(:project_user, project: project, user: user, role: :member)
    end
  end

  let(:story) { create(:story, project: project, board: board, owner: story_owner, user: story_user) }
  let(:comment) { create(:comment, story: story, user: commenter) }

  describe "slack delivery" do
    context "when active slack integration exists with comment_created event" do
      it "delivers to slack" do
        expect {
          perform_enqueued_jobs do
            described_class.with(comment: comment).deliver
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

            text_blocks.any? { |t| t.include?("New Comment") }
            text_blocks.any? { |t| t.include?("#comment_#{comment.id}") }
          }
      end
    end

    context "when inactive slack integration exists with comment_created event" do
      it "does not deliver to slack" do
        slack_integration.update(active: false)
        expect {
          perform_enqueued_jobs do
            described_class.with(comment: comment).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, slack_integration.webhook_url).twice
      end
    end

    context "when active slack integration exists without comment_created event" do
      it "does not deliver to slack" do
        slack_integration.update(events: [])
        expect {
          perform_enqueued_jobs do
            described_class.with(comment: comment).deliver
          end
        }.not_to raise_error
        expect(WebMock).not_to have_requested(:post, slack_integration.webhook_url)
      end
    end
  end

  describe "email delivery" do
    let(:story) { create(:story, project: project, board: board, owner: story_owner, user: story_user) }

    it "delivers email to story owner and assigned user" do
      expect {
        perform_enqueued_jobs do
          create(:comment, story: story, user: commenter)
        end
      }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end

    context "when story has no assigned user" do
      let(:story) { create(:story, project: project, board: board, owner: story_owner, user: nil) }

      it "delivers email to story owner only" do
        expect {
          perform_enqueued_jobs do
            create(:comment, story: story, user: commenter)
          end
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when owner and assigned user are the same" do
      let(:story) { create(:story, project: project, board: board, owner: story_owner, user: story_owner) }

      it "delivers email once" do
        expect {
          perform_enqueued_jobs do
            create(:comment, story: story, user: commenter)
          end
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
