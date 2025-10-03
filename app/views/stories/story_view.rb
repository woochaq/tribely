class Views::Stories::StoryView < Components::Base
  include Phlex::Rails::Helpers::DOMID
  def initialize(story:)
    @story = story
  end

  def view_template
    div(id: dom_id(@story), class: "w-full sm:w-auto my-5 space-y-5") do
      div do
        strong(class: "block font-medium mb-1") { "Project:" }
        plain @story.board.project.name
      end
      div do
        strong(class: "block font-medium mb-1") { "Title:" }
        plain @story.title
      end
      div do
        strong(class: "block font-medium mb-1") { "Description:" }
        plain @story.description
      end
      div do
        strong(class: "block font-medium mb-1") { "Status:" }
        plain @story.status
      end
      div do
        strong(class: "block font-medium mb-1") { "Story type:" }
        plain @story.story_type
      end
    end
  end
end
