class StoryCreatedNotifier < ApplicationNotifier
  include SlackMessageHelper

  required_params :story, :author

  deliver_by :slack, if: -> { recipient.is_a?(Integrations::Slack) && recipient.active && recipient.events.include?("story_created") } do |config|
    config.url = -> { recipient.webhook_url }
    config.json = -> {
      story = params[:story]
      author = params[:author]
      project = story.project

      {
        blocks: [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*New Story Created* in *#{project.name}*"
            }
          },
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*<#{project_story_url(project, story)}|#{story.prefix_with_number} #{story.title}>*\nCreated by: #{author.name}"
            }
          },
          {
            type: "context",
            elements: story_context_elements(story)
          }
        ]
      }
    }
  end

  recipients do
    story = params[:story]
    recipients = []
    if story.present?
      recipients += story.project.active_integrations_for(:story_created)
    end
    recipients
  end
end
