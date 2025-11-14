class Components::Comments::EditForm < Components::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::DOMClass

  register_element def lexxy_prompt(**attributes, &content) = nil

  def initialize(story:, comment:)
    @story = story
    @comment = comment
  end

  def view_template
    turbo_frame_tag dom_id(@comment) do
      div(class: "py-4") do
        simple_form_for([ @story.project, @story, @comment ]) do |f|
          f.rich_text_area :content, label: false, placeholder: "Add a comment...", autofocus: true, class: "lexxy-content wysiwyg-editor prose max-w-none" do
            lexxy_prompt(
              trigger: "@",
              src: view_context.project_users_mentions_path(@story.project),
              name: "mention",
              "remote-filtering": true,
              "supports-space-in-searches": true
            )
            lexxy_prompt(
              trigger: "#",
              src: mentions_project_stories_path(@story.project),
              name: "mention",
              "remote-filtering": true,
              "supports-space-in-searches": true
            )
          end
          div(class: "flex justify-end items-center gap-4 mt-2") do
            link_to "Cancel", project_story_comment_path(@story.project, @story, @comment), class: "text-sm"
            f.button :submit, "Save changes", class: "btn-primary"
          end
        end
      end
    end
  end

  private

  def project_story_comment_path(project, story, comment)
    view_context.project_story_comment_path(project, story, comment)
  end
end
