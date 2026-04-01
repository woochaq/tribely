module DiscordMessageHelper
  extend ActiveSupport::Concern

  included do
    notification_methods do
      def discord_status_emoji(status)
        case status
        when "todo" then "⬜"
        when "in_progress" then "🟦"
        when "in_review" then "👀"
        when "done" then "✅"
        when "archived" then "📦"
        else "▪️"
        end
      end

      def discord_type_emoji(type)
        case type
        when "feature" then "✨"
        when "bug" then "🐞"
        when "chore" then "🔧"
        when "spike" then "💡"
        else "📝"
        end
      end

      def discord_story_fields(story)
        assignee_text = story.user ? story.user.name : "Unassigned"

        [
          {
            name: "Status",
            value: "#{discord_status_emoji(story.status)} #{story.status.humanize}",
            inline: true
          },
          {
            name: "Type",
            value: "#{discord_type_emoji(story.story_type)} #{story.story_type.humanize}",
            inline: true
          },
          {
            name: "Assignee",
            value: "👤 #{assignee_text}",
            inline: true
          }
        ]
      end
    end
  end
end
