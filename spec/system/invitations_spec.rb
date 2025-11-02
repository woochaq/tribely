require 'rails_helper'

RSpec.describe "Invitations", type: :system do
  let(:organization) { create(:organization) }
  let(:owner) { create(:user) }

  before do
    create(:organization_user, organization: organization, user: owner, role: :owner)
    sign_in owner
  end

  it 'allows an owner to invite, see the pending invitation, and then cancel it' do
    visit members_organization_path(organization)

    # Invite a new member
    fill_in 'invitation_email', with: 'new_member@example.com'
    select 'Member', from: 'invitation_role'
    click_button 'Send Invitation'

    expect(page).to have_content('Invitation sent successfully.')
    expect(page).to have_content('Pending Invitations')
    expect(page).to have_content('new_member@example.com')
    expect(page).to have_content('as Member')

    # Cancel the invitation
    within '.pending-invitations' do
      accept_confirm do
        find('form[action*="/invitations/"][data-turbo-confirm]').find('button[type="submit"]').click
      end
    end

    expect(page).to have_content('Invitation cancelled successfully.')
    expect(page).not_to have_content('Pending Invitations')
    expect(page).not_to have_content('new_member@example.com')
  end
end
