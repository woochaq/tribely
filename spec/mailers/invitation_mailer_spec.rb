require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe 'invitation_email' do
    let(:organization) { create(:organization, name: 'Test Corp') }
    let(:sender) { create(:user, full_name: 'John Doe') }
    let(:invitation) { create(:invitation, organization: organization, sender: sender, email: 'new_member@example.com') }
    let(:mail) { InvitationMailer.invitation_email(invitation) }

    before do
      organization.users << sender
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('You have been invited to join Test Corp')
      expect(mail.to).to eq([ 'new_member@example.com' ])
      expect(mail.from).to eq([ 'contact@tribely.work' ])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(sender.name)
      expect(mail.body.encoded).to match(organization.name)
      expect(mail.body.encoded).to match(accept_invitation_url(token: invitation.token))
    end
  end
end
