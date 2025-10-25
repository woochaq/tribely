class Components::Comments::Comment < Components::Base
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TimeAgoInWords

  def initialize(comment:)
    @comment = comment
  end

  def view_template
    div(id: dom_id(@comment), class: "flex gap-4 py-4") do
      render Components::Shared::Avatar.new(user: @comment.user)

      div(class: "flex-1") do
        div(class: "flex items-center justify-between") do
          div(class: "flex items-center gap-2") do
            p(class: "font-semibold text-text") { @comment.user.name || @comment.user.email }
            p(class: "text-xs text-subtext0") { "#{time_ago_in_words(@comment.created_at)} ago" }
          end
          # Placeholder for edit/delete actions
          div(class: "flex items-center gap-2") do
            link_to "Edit", "#", class: "text-sm text-subtext0 hover:text-text"
            link_to "Delete", project_story_comment_path(@comment.story.board.project, @comment.story, @comment),
              data: { turbo_method: :delete, turbo_confirm: "Are you sure?" },
              class: "text-sm text-danger hover:underline"
          end
        end
        div(class: "lexxy-content prose max-w-none mt-2") do
          safe(@comment.content.to_s)
        end
      end
    end
  end
end
