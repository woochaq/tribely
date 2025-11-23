class NewCommentNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = "CommentMailer"
    config.method = "new_comment_notification"
    config.params = -> { { author: params[:comment].user, comment: params[:comment] } }
  end

  required_param :comment

  recipients do
    comment = params[:comment]
    story = comment.story
    recipients = [ story.owner, story.user ].compact.uniq
    recipients.delete(comment.user)
    recipients
  end
end
