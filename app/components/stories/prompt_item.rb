class Components::Stories::PromptItem < Components::Base
  attr_reader :story

  register_element def lexxy_prompt_item(**attributes, &content) = nil

  def initialize(story:)
    @story = story
  end

  def view_template
    lexxy_prompt_item(search: "#{story.prefix_with_number} #{story.title}", sgid: story.attachable_sgid) do
      template(type: "menu") do
        div(class: "flex items-center gap-x-2") do
          span { story.prefix_with_number }
          div(class: "h-6 w-px bg-crust lg:hidden", "aria-hidden": "true")
          span { story.title }
        end
      end
      template(type: "editor") do
        render Components::Stories::Mention.new(story: story)
      end
    end
  end
end
