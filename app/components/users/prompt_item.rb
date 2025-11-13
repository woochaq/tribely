class Components::Users::PromptItem < Components::Base
  attr_reader :user

  register_element def lexxy_prompt_item(**attributes, &content) = nil

  def initialize(user:)
    @user = user
  end

  def view_template
    lexxy_prompt_item(search: "#{user.name} #{user.email}", sgid: user.attachable_sgid) do
      template(type: "menu") do
        div(class: "flex items-center gap-x-2") do
          render Components::Shared::Avatar.new(user: user, size: "w-6 h-6")
          span { user.name }
        end
      end
      template(type: "editor") do
        render Components::Users::Mention.new(user: user)
      end
    end
  end
end
