class Components::Comments::Index < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::LinkTo

  def initialize(story:)
    @story = story
  end

  def view_template
    div(class: "mt-8 pt-6 border-t border-crust") do
      h2(class: "text-xl font-semibold text-text mb-4") { "Comments" }

      render Components::Comments::NewCommentPlaceholder.new(story: @story)

      div(class: "my-6 border-t border-surface0")

      div(id: dom_id(@story, "comments")) do
        @story.comments.order(created_at: :desc).each do |comment|
          render Components::Comments::Comment.new(comment: comment, current_user: current_user)
        end
      end
    end
  end
end
