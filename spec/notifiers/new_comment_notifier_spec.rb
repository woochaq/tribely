require 'rails_helper'

RSpec.describe NewCommentNotifier, type: :notifier do
  describe "recipients" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:board) { create(:board, project: project) }
    let(:story_owner) { create(:user, email: "owner@example.com") }
    let(:story_user) { create(:user, email: "user@example.com") }
    let(:commenter) { create(:user, email: "commenter@example.com") }
    let(:other_commenter) { create(:user, email: "other@example.com") }

    before do
      [ story_owner, story_user, commenter, other_commenter ].each do |user|
        create(:organization_user, organization: organization, user: user, role: :member)
        create(:project_user, project: project, user: user, role: :member)
      end
    end

    let(:story) { create(:story, board: board, owner: story_owner, user: story_user) }

    context "when a third party comments" do
      it "notifies the story owner and the assigned user" do
        comment = create(:comment, story: story, user: commenter)
        expect {
          described_class.with(comment: comment).deliver
        }.to change { story_owner.notifications.count }.by(1)
         .and change { story_user.notifications.count }.by(1)
         .and change { commenter.notifications.count }.by(0)
      end
    end

    context "when the story owner comments" do
      it "notifies the assigned user but not the owner" do
        comment = create(:comment, story: story, user: story_owner)
        expect {
          described_class.with(comment: comment).deliver
        }.to change { story_user.notifications.count }.by(1)
         .and change { story_owner.notifications.count }.by(0)
      end
    end

    context "when the assigned user comments" do
      it "notifies the story owner but not the assigned user" do
        comment = create(:comment, story: story, user: story_user)
        expect {
          described_class.with(comment: comment).deliver
        }.to change { story_owner.notifications.count }.by(1)
         .and change { story_user.notifications.count }.by(0)
      end
    end

    context "when the owner and assigned user are the same" do
      let(:story) { create(:story, board: board, owner: story_owner, user: story_owner) }

      it "does not duplicate notifications" do
        comment = create(:comment, story: story, user: commenter)
        expect {
          described_class.with(comment: comment).deliver
        }.to change { story_owner.notifications.count }.by(1)
      end
    end

    context "when the story has no assigned user" do
      let(:story) { create(:story, board: board, owner: story_owner, user: nil) }

      it "notifies the story owner" do
        comment = create(:comment, story: story, user: commenter)
        expect {
          described_class.with(comment: comment).deliver
        }.to change { story_owner.notifications.count }.by(1)
      end
    end
  end

  describe "delivery methods" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:board) { create(:board, project: project) }
    let(:story_owner) { create(:user) }
    let(:commenter) { create(:user) }

    before do
      create(:organization_user, organization: organization, user: story_owner, role: :member)
      create(:project_user, project: project, user: story_owner, role: :member)
      create(:organization_user, organization: organization, user: commenter, role: :member)
      create(:project_user, project: project, user: commenter, role: :member)
    end

    let(:story) { create(:story, board: board, owner: story_owner) }
    let!(:comment) { create(:comment, story: story, user: commenter) }

    it "delivers to database" do
      expect { described_class.with(comment: comment).deliver }.to change(Noticed::Notification, :count).by(1)
    end

    it "delivers by email" do
      expect {
        perform_enqueued_jobs do
          described_class.with(comment: comment).deliver
        end
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
