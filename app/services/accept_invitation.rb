class AcceptInvitation
  def self.call(invitation:, user:)
    new(invitation: invitation, user: user).call
  end

  def initialize(invitation:, user:)
    @invitation = invitation
    @user = user
  end

  def call
    ActiveRecord::Base.transaction do
      @invitation.update!(recipient: @user, status: :accepted)
      @invitation.organization.organization_users.find_or_create_by!(user: @user) do |ou|
        ou.role = @invitation.role
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    # You can add logging here if needed, e.g., Rails.logger.error(e.message)
    false
  end

  private

  attr_reader :invitation, :user
end
