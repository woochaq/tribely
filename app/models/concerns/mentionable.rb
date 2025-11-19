module Mentionable
  extend ActiveSupport::Concern

  included do
    after_commit :send_mention_notifications, on: [ :create, :update ]
  end

  private

  def send_mention_notifications
    rich_text_attribute_name = self.class.rich_text_association_names.first
    return unless rich_text_attribute_name

    rich_text_association = send(rich_text_attribute_name)
    return unless rich_text_association&.saved_change_to_body?

    previous_body = rich_text_association.body_before_last_save
    current_body = rich_text_association.body

    previous_mentions = extract_mentioned_users(previous_body)
    current_mentions = extract_mentioned_users(current_body)

    newly_mentioned_users = current_mentions - previous_mentions

    newly_mentioned_users.each do |mentioned_user|
      mentioner = if self.is_a?(Story)
        owner
      elsif self.is_a?(Document)
        last_updated_by
      else
        user
      end
      next if mentioned_user == mentioner # Don't notify the author about their own mention

      NotificationMailer.user_mentioned(mentioned_user, mentioner, self).deliver_later
    end
  end

  def extract_mentioned_users(rich_text_body)
    return [] if rich_text_body.blank?
    rich_text_body.attachments.filter_map do |attachment|
      attachment.attachable if [ User, Document ].include?(attachment.attachable.class)
    end.uniq
  end
end
