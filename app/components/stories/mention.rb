class Components::Stories::Mention < Components::Base
  include Phlex::Rails::Helpers::LinkTo

  attr_reader :story

  def initialize(story:)
    @story = story
  end

  def view_template
    link_to(project_story_path(story.project, story), { target: :_blank, method: :get, data: { turbo: false } }) do
      em(class: "text-primary font-semibold") { "##{story.prefix_with_number}" }
    end
  end
end
