class Components::Users::Mention < Components::Base
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def view_template
    em(class: "text-primary font-semibold") { "@" + user.name }
  end
end
