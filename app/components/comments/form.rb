class Components::Comments::Form < Components::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  register_element def lexxy_prompt(**attributes, &content) = nil

  def initialize(story:, comment:)
    @story = story
    @comment = comment
  end

  def view_template
    turbo_frame_tag dom_id(@story, "new_comment_form") do
      div(class: "mt-6") do
        div(id: dom_id(@comment, :form)) do
          simple_form_for([ @story.project, @story, @comment ], html: { data: { turbo_frame: dom_id(@story, "comments_form"), turbo_progress_bar: true  } }) do |f|
            f.rich_text_area :content, label: false, placeholder: "Add a comment...", class: "lexxy-content wysiwyg-editor prose max-w-none" do
              render Components::Shared::LexxyPrompts.new(project: @story.project)
            end
            if f.object.errors[:content].present?
              p(class: "mt-2 text-sm text-danger flex items-center gap-1") { f.object.errors[:content].join(", ") }
            end
            div(class: "flex justify-end mt-2") do
              f.button :submit, "Comment", class: "btn-primary"
            end
          end
        end
      end
    end
  end
end
