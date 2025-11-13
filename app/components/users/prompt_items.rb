class Components::Users::PromptItems < Components::Base
  attr_reader :users

  def initialize(users:)
    @users = users
  end

  def view_template
    users.each do |user|
      render Components::Users::PromptItem.new(user: user)
    end
  end
end
