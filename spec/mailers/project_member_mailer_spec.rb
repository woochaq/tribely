require "rails_helper"

RSpec.describe ProjectMemberMailer, type: :mailer do
  describe 'added_to_project_email' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, full_name: 'Jane Doe') }
    let(:added_by_user) { create(:user, full_name: 'John Smith') }
    let(:project) { create(:project, organization: organization) }
    let(:project_user) { create(:project_user, project: project, user: user, added_by: added_by_user) }
    let(:mail) { ProjectMemberMailer.with(project_user: project_user).added_to_project_email }

    before do
      create(:organization_user, organization: organization, user: user, role: :owner)
      create(:organization_user, organization: organization, user: added_by_user, role: :owner)
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("You have been added to the project: #{project.name}")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ 'no-reply@tribely.work' ])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("Hi #{user.name},")
      expect(mail.body.encoded).to match("#{added_by_user.name} has added you to the project")
      expect(mail.body.encoded).to match(project.name)
      expect(mail.body.encoded).to match(project_url(project))
    end
  end
end
