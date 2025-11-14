require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "user_mentioned" do
    let(:mentioned_user) { create(:user, email: "mentioned@example.com", full_name: "Jane Doe") }
    let(:organization) { mentioned_user.organizations.first }
    let(:mentioner) { create(:user, full_name: "John Smith") }
    let(:project) { create(:project, organization: organization) }
    before do
      organization.users << mentioner
      project.users << mentioned_user
      project.users << mentioner
    end
    let(:story) { create(:story, board: project.boards.first, title: "Test Story", owner: mentioner) }
    let(:comment) { create(:comment, story: story, user: mentioner) }

    context "when mentioned in a comment" do
      let(:mail) { NotificationMailer.user_mentioned(mentioned_user, mentioner, comment) }

      it "renders the headers" do
        expect(mail.subject).to eq("John Smith mentioned you in a comment")
        expect(mail.to).to eq([ "mentioned@example.com" ])
        expect(mail.from).to eq([ "no-reply@tribely.work" ])
      end

      it "renders the body" do
        body = mail.body.encoded
        expect(body).to match("Hi Jane Doe")
        expect(body).to match("John Smith mentioned you in a comment")
        expect(body).to include(project_story_url(project, story))
      end
    end

    context "when mentioned in a story description" do
      let(:mail) { NotificationMailer.user_mentioned(mentioned_user, mentioner, story) }

      it "renders the headers" do
        expect(mail.subject).to eq("John Smith mentioned you in a story")
        expect(mail.to).to eq([ "mentioned@example.com" ])
      end

      it "renders the body" do
        body = mail.body.encoded
        expect(body).to match("Hi Jane Doe")
        expect(body).to match("John Smith mentioned you in a story")
        expect(body).to include(project_story_url(project, story))
      end
    end
  end
end
