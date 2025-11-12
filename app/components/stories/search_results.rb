class Components::Stories::SearchResults < Components::Base
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :stories, :current_project

  def initialize(stories:, current_project:)
    @stories = stories
    @current_project = current_project
  end

  def view_template
    turbo_frame_tag "search_results" do
      div(class: "fixed top-16 inset-x-4 z-10 rounded-md bg-surface1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none md:absolute md:top-full md:w-[500px] md:inset-x-auto md:left-0", data: { "search-stories-target": "results" }) do
        if stories.any?
          stories.each do |story|
            link_to project_story_path(current_project, story), data: { turbo_frame: "modal", action: "click->search-stories#clearResults" }, class: "block px-4 py-2 text-sm text-text hover:bg-surface2 cursor-pointer" do
              div(class: "flex items-center gap-x-2") do
                span(class: "font-semibold w-16 flex-shrink-0") { story.prefix_with_number }
                span(class: "truncate") { story.title }
              end
            end
          end
        else
          div(class: "px-4 py-2 text-sm text-subtext1") { "No stories found." }
        end
      end
    end
  end
end
