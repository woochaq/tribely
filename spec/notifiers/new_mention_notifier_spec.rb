require 'rails_helper'

RSpec.describe NewMentionNotifier, type: :notifier do
  describe "delivery methods" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization) }
    let(:board) { create(:board, project: project) }
    let(:mentioner) { create(:user) }
    let(:recipient) { create(:user) }

    before do
      create(:organization_user, organization: organization, user: mentioner, role: :member)
      create(:project_user, project: project, user: mentioner, role: :member)
      create(:organization_user, organization: organization, user: recipient, role: :member)
      create(:project_user, project: project, user: recipient, role: :member)
    end

    let(:story) { create(:story, board: board, owner: mentioner) }

    it "delivers to database" do
      expect { described_class.with(model_record: story, mentioner: mentioner, recipient: recipient).deliver }.to change(Noticed::Notification, :count).by(1)
      notification = Noticed::Notification.last
      expect(notification.recipient).to eq(recipient)
      expect(notification.type).to eq("NewMentionNotifier::Notification")
      expect(notification.params[:model_record]).to eq(story)
      expect(notification.params[:mentioner]).to eq(mentioner)
      expect(notification.params[:recipient]).to eq(recipient)
    end

    it "delivers by email" do
      expect {
        perform_enqueued_jobs do
          described_class.with(model_record: story, mentioner: mentioner, recipient: recipient).deliver
        end
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
