class AssignedToStoryNotifier < ApplicationNotifier
  include SlackMessageHelper
  include DiscordMessageHelper

  deliver_by :email, if: -> { recipient.is_a?(User) } do |config|
    config.mailer = "NotificationMailer"
    config.method = "user_assigned_to_story_email"
    config.params = -> { { story: params[:story], assigner: params[:assigner], assigned_user: params[:assigned_user] } }
  end

  deliver_by :slack, if: -> { recipient.is_a?(Integrations::Slack) && recipient.active && recipient.events.include?("story_assigned") } do |config|
    config.url = -> { recipient.webhook_url }
    config.json = -> {
      story = params[:story]
      assigner = params[:assigner]
      assigned_user = params[:assigned_user]
      project = story.project

      {
        blocks: [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*Story Assigned* in *#{project.name}*"
            }
          },
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "*<#{project_story_url(project, story)}|#{story.prefix_with_number} #{story.title}>*\nAssigned to *#{assigned_user.name}* by #{assigner.name}"
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

  deliver_by :discord, class: "DeliveryMethods::Discord", if: -> { recipient.is_a?(Integrations::Discord) && recipient.active && recipient.events.include?("story_assigned") } do |config|
    config.url = -> { recipient.webhook_url }
    config.json = -> {
      story = params[:story]
      assigner = params[:assigner]
      assigned_user = params[:assigned_user]
      project = story.project

      {
        embeds: [
          {
            title: "Story Assigned in #{project.name}",
            description: "**[#{story.prefix_with_number} #{story.title}](#{project_story_url(project, story)})**\nAssigned to **#{assigned_user.name}** by #{assigner.name}",
            color: 5793266,
            fields: discord_story_fields(story)
          }
        ]
      }
    }
  end

  required_params :story, :assigner, :assigned_user

  recipients do
    recipients = [ params[:assigned_user] ]
    if params[:story].present?
      recipients += params[:story].project.active_integrations_for(:story_assigned)
    end
    recipients
  end
end
