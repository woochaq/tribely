class NewCommentNotifier < ApplicationNotifier
  include SlackMessageHelper
  include DiscordMessageHelper

  deliver_by :email, if: -> { recipient.is_a?(User) } do |config|
    config.mailer = "CommentMailer"
    config.method = "new_comment_notification"
    config.params = -> { { author: params[:comment].user, comment: params[:comment] } }
  end

  deliver_by :slack, if: -> { recipient.is_a?(Integrations::Slack) && recipient.active && recipient.events.include?("comment_created") } do |config|
    config.url = -> { recipient.webhook_url }
    config.json = -> {
      comment = params[:comment]
      story = comment.story
      project = story.project

      {
        blocks: [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*New Comment* on *#{project.name}*"
            }
          },
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*<#{project_story_url(project, story, anchor: "comment_#{comment.id}")}|#{story.prefix_with_number} #{story.title}>*\nComment by: #{comment.user.name}"
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

  deliver_by :discord, class: "DeliveryMethods::Discord", if: -> { recipient.is_a?(Integrations::Discord) && recipient.active && recipient.events.include?("comment_created") } do |config|
    config.url = -> { recipient.webhook_url }
    config.json = -> {
      comment = params[:comment]
      story = comment.story
      project = story.project

      {
        embeds: [
          {
            title: "New Comment on #{project.name}",
            description: "**[#{story.prefix_with_number} #{story.title}](#{project_story_url(project, story, anchor: "comment_#{comment.id}")})**\nComment by: #{comment.user.name}",
            color: 5793266,
            fields: discord_story_fields(story)
          }
        ]
      }
    }
  end

  required_param :comment

  recipients do
    comment = params[:comment]
    story = comment.story
    recipients = [ story.owner, story.user ].compact.uniq
    recipients.delete(comment.user)
    if story.present?
      recipients += story.project.active_integrations_for(:comment_created)
    end
    recipients
  end
end
