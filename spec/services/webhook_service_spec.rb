require 'rails_helper'

RSpec.describe WebhookService do
  let(:organization) { create(:organization) }
  let(:project) { create(:project, organization: organization) }
  let(:board) { create(:board, project: project) }
  let(:owner) { create(:user) }
  let(:webhook) { create(:webhook, project: project, board: board, webhook_type: :create_story, created_by: owner) }
  let(:payload) { { "title" => "New Story", "description" => "Description", "story_type" => "bug" } }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    create(:project_user, project: project, user: owner, role: :owner)
  end

  subject { described_class.new(webhook, payload) }

  describe '#process' do
    context 'when webhook type is create_story' do
      it 'creates a new story with correct attributes' do
        expect { subject.process }.to change(Story, :count).by(1)

        story = Story.last
        expect(story.title).to eq("New Story")
        expect(story.project).to eq(project)
        expect(story.board).to eq(board)
        expect(story.owner).to eq(webhook.created_by)
        expect(story.story_type).to eq("bug")
      end

      it 'uses default values when optional attributes are missing' do
        minimal_payload = { "title" => "Minimal Story" }
        service = described_class.new(webhook, minimal_payload)

        expect { service.process }.to change(Story, :count).by(1)

        story = Story.last
        expect(story.title).to eq("Minimal Story")
        expect(story.story_type).to eq("feature") # default
        expect(story.status).to eq("todo") # default
      end
    end
  end
end
