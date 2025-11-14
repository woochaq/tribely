module Mentionable
  extend ActiveSupport::Concern

  included do
    before_save :store_previous_mentions
    after_commit :send_mention_notifications, on: [ :create, :update ]
  end

  private

  def store_previous_mentions
    rich_text_attribute = self.class.rich_text_association_names.first
    return if self.send(rich_text_attribute).nil?
    return unless rich_text_attribute && self.send(rich_text_attribute).body_changed?

    @previous_mentions = extract_mentioned_users(self.send(rich_text_attribute).body_was)
  end

  def send_mention_notifications
    rich_text_attribute = self.class.rich_text_association_names.first
    return unless rich_text_attribute

    current_mentions = extract_mentioned_users(self.send(rich_text_attribute).body)
    previous_mentions = @previous_mentions || []

    newly_mentioned_users = current_mentions - previous_mentions

    newly_mentioned_users.each do |mentioned_user|
      next if mentioned_user == (self.user) # Don't notify the author
      mentioner = self.kind_of?(Story) ? self.owner : self.user
      NotificationMailer.user_mentioned(mentioned_user, mentioner, self).deliver_later
    end

    @previous_mentions = nil
  end

  def extract_mentioned_users(rich_text_body)
    return [] if rich_text_body.blank?
    rich_text_body.attachments.filter_map do |attachment|
      attachment.attachable if attachment.attachable.is_a?(User) && attachment.attachable.content_type == "application/vnd.actiontext.mention"
    end.uniq
  end
end
