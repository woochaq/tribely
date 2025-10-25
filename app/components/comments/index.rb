class Components::Comments::Index < Components::Base
  include Phlex::Rails::Helpers::DOMID

  def initialize(story:)
    @story = story
  end

  def view_template
    div(class: "mt-8 pt-6 border-t border-crust") do
      h2(class: "text-xl font-semibold text-text mb-4") { "Comments" }

      render Components::Comments::Form.new(story: @story, comment: ::Comment.new(user: view_context.current_user))

      div(id: dom_id(@story, "comments"), data: { controller: "syntax-highlight" }) do
        @story.comments.order(created_at: :desc).each do |comment|
          render Components::Comments::Comment.new(comment: comment)
        end
      end
    end
  end
end
