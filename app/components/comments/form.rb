class Components::Comments::Form < Components::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(story:, comment:)
    @story = story
    @comment = comment
  end

  def view_template
    turbo_frame_tag dom_id(@story, "new_comment_form") do
      div(class: "mt-6") do
        div(id: dom_id(@comment, :form)) do
          simple_form_for([ @story.board.project, @story, @comment ], html: { data: { turbo_frame: dom_id(@story, "comments_form") } }) do |f|
            f.input :content, as: :rich_text_area, label: false, placeholder: "Add a comment...", autofocus: true, input_html: { class: "lexxy-content wysiwyg-editor prose max-w-none" }
            div(class: "flex justify-end mt-2") do
              f.button :submit, "Comment", class: "btn-primary"
            end
          end
        end
      end
    end
  end
end
