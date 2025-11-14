class Components::Stories::PromptItems < Components::Base
  attr_reader :stories

  def initialize(stories:)
    @stories = stories
  end

  def view_template
    stories.each do |story|
      render Components::Stories::PromptItem.new(story: story)
    end
  end
end
