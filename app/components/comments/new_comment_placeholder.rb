class Components::Comments::NewCommentPlaceholder < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag

  def initialize(story:)
    @story = story
  end

  def view_template
    turbo_frame_tag dom_id(@story, "new_comment_form") do
      div(class: "mt-6") do
        link_to "Add a comment...", view_context.new_project_story_comment_path(@story.project, @story),
          class: "block w-full px-3 py-2 border border-surface1 rounded-md text-subtext0"
      end
    end
  end
end
