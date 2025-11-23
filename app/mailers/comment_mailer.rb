class CommentMailer < ApplicationMailer
  def new_comment_notification
    @recipient = params[:recipient]
    @author    = params[:author]
    @comment   = params[:comment]
    @story = @comment.story
    @project = @story.project

    mail(
      to: @recipient.email,
      subject: "New comment on story ##{@project.prefix}-#{@story.number}"
    )
  end
end
