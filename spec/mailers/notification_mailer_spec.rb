require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "user_mentioned" do
    let(:mentioned_user) { create(:user, email: "mentioned@example.com", full_name: "Jane Doe") }
    let(:organization) { mentioned_user.organizations.first }
    let(:mentioner) { create(:user, full_name: "John Smith") }
    let(:project) { create(:project, name: "Tribely", prefix: "TRB", organization: organization) }
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
        expect(mail.subject).to eq("(Tribely) John Smith mentioned you in a comment of story: #{story.prefix_with_number}")
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
        expect(mail.subject).to eq("(Tribely) John Smith mentioned you in a story: #{story.prefix_with_number}")
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

  describe "user_assigned_to_story_email" do
    let(:assigned_user) { create(:user, email: "assigned@example.com", full_name: "Assigned User") }
    let(:assigner) { create(:user, full_name: "Assigner User") }
    let(:organization) { assigned_user.organizations.first }
    let(:project) { create(:project, name: "Test Project", prefix: "TP", organization: organization) }
    let(:story) { create(:story, board: project.boards.first, title: "New Task", owner: assigner) }
    let(:mail) { NotificationMailer.user_assigned_to_story_email(assigned_user, assigner, story) }

    before do
      organization.users << assigner
      project.users << assigned_user
      project.users << assigner
    end

    it "renders the headers" do
      expect(mail.subject).to eq("(Test Project) Assigner User assigned you to a story: #{story.prefix_with_number}")
      expect(mail.to).to eq([ "assigned@example.com" ])
      expect(mail.from).to eq([ "no-reply@tribely.work" ])
    end

    it "renders the body" do
      body = mail.body.encoded
      expect(body).to match("Hi Assigned User")
      expect(body).to match("Assigner User assigned you to the story")
      expect(body).to match(story.title)
      expect(body).to match(project.name)
      expect(body).to include(project_story_url(project, story))
    end
  end
end
