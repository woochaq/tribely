class Components::Documents::PromptItem < Components::Base
  register_element def lexxy_prompt_item(**attributes, &content) = nil

  def initialize(document:)
    @document = document
  end

  def view_template
    lexxy_prompt_item(search: "#{@document.title}", sgid: @document.attachable_sgid) do
      template(type: "menu") do
        div(class: "flex items-center gap-x-2") do
          span { @document.title }
        end
      end
      template(type: "editor") do
        render Components::Documents::Mention.new(document: @document)
      end
    end
  end
end
