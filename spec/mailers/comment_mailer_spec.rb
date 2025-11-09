require "rails_helper"

RSpec.describe CommentMailer, type: :mailer do
  describe "new_comment_notification" do
    let(:organization) { create(:organization) }
    let(:project) { create(:project, organization: organization, prefix: "PROJ") }
    let(:recipient) { create(:user, email: "recipient@example.com", full_name: "Recipient User") }
    let(:author) { create(:user, email: "author@example.com", full_name: "Author User") }
    before do
      create(:organization_user, organization: organization, user: recipient, role: :owner)
      create(:organization_user, organization: organization, user: author, role: :member)
      create(:project_user, project: project, user: recipient, role: :member)
      create(:project_user, project: project, user: author, role: :member)
    end
    let!(:story) { create(:story, board: project.boards.first, project: project, title: "Test Story", owner: recipient) }
    let(:comment) { create(:comment, story: story, user: author) }
    let(:mail) { CommentMailer.new_comment_notification(recipient: recipient, author: author, comment: comment) }


    it "renders the headers" do
      expect(mail.subject).to eq("New comment on story #PROJ-#{story.number}")
      expect(mail.to).to eq([ "recipient@example.com" ])
      expect(mail.from).to eq([ "no-reply@tribely.work" ])
    end

    it "renders the body with correct information" do
      expect(mail.html_part.body.encoded).to match(author.name)
      expect(mail.html_part.body.encoded).to match(story.title)
      expect(mail.html_part.body.encoded).to include(project_story_url(project, story, anchor: "comment_#{comment.id}"))

      expect(mail.text_part.body.encoded).to match(author.name)
      expect(mail.text_part.body.encoded).to match(story.title)
      expect(mail.text_part.body.encoded).to include(project_story_url(project, story, anchor: "comment_#{comment.id}"))
    end
  end
end
