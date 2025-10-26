class Components::Stories::Story < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::DOMID

  def initialize(story:)
    @story = story
  end

  def view_template
    div(
      id: dom_id(@story),
      data: { "story-id": @story.id },
      class: "block bg-surface0 border border-crust rounded-lg p-3 shadow-sm hover:bg-surface1 cursor-grab"
    ) do
      link_to(
        project_story_path(@story.board.project, @story),
        data: { turbo_frame: "modal" },
        class: "block w-full"
      ) do
        div(class: "flex items-start gap-2") do
          p(class: "font-semibold text-text") { @story.title }
        end
        div(class: "flex items-center justify-between mt-4") do
          div(class: "flex items-center gap-2") do
            story_type_icon
            span(class: "text-xs text-subtext0") { "#{@story.board.project.prefix}-#{@story.number}" }
          end
          div(class: "flex items-center gap-2") do
            render Components::Shared::StatusBadge.new(status: @story.status)
            render Components::Shared::Avatar.new(user: @story.user, size: "w-6 h-6", bg: "bg-info/50", font_size: "text-xs")
          end
        end
      end
    end
  end

  private

  def story_type_icon
    case @story.story_type
    when "feature"
      render Components::Icons::FeatureStory.new
    when "bug"
      render Components::Icons::BugStory.new
    when "chore"
      render Components::Icons::ChoreStory.new
    when "spike"
      render Components::Icons::SpikeStory.new
    end
  end
end
