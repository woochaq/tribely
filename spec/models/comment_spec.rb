require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validation" do
    it { should validate_presence_of(:content) }
  end

  describe "broadcasts" do
    let!(:comment) { create(:comment) }
    let(:project) { comment.story.board.project }
    let(:story) { comment.story }

    it "enqueues a broadcast job on create" do
      new_comment = build(:comment, story: story)
      expect { new_comment.save! }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
    end

    it "enqueues a broadcast job on update" do
      expect { comment.update!(content: "updated content") }.to have_enqueued_job(Turbo::Streams::ActionBroadcastJob)
    end

    it "triggers a broadcast on destroy" do
      expect(comment).to receive(:broadcast_destroy)
      comment.destroy!
    end
  end
end
