module SlackMessageHelper
  extend ActiveSupport::Concern

  included do
    notification_methods do
      def status_emoji(status)
        case status
        when "todo" then "⬜"
        when "in_progress" then "🟦"
        when "in_review" then "👀"
        when "done" then "✅"
        when "archived" then "📦"
        else "▪️"
        end
      end

      def type_emoji(type)
        case type
        when "feature" then "✨"
        when "bug" then "🐞"
        when "chore" then "🔧"
        when "spike" then "💡"
        else "📝"
        end
      end

      def story_context_elements(story)
        assignee_text = story.user ? story.user.name : "Unassigned"

        [
          {
            type: "mrkdwn",
            text: "#{status_emoji(story.status)} *Status:* #{story.status.humanize}"
          },
          {
            type: "mrkdwn",
            text: "#{type_emoji(story.story_type)} *Type:* #{story.story_type.humanize}"
          },
          {
            type: "mrkdwn",
            text: "👤 *Assignee:* #{assignee_text}"
          }
        ]
      end
    end
  end
end
