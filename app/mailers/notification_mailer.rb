class NotificationMailer < ApplicationMailer
  def user_mentioned(mentioned_user, mentioner, mentionable)
    @mentioned_user = mentioned_user
    @mentioner = mentioner
    @mentionable = mentionable

    @project, mention_description, type_name = mentionable_details
    subject = build_subject(mention_description, type_name)
    mail to: @mentioned_user.email, subject: subject
  end

  def user_assigned_to_story_email(assigned_user, assigner, story)
    @assigned_user = assigned_user
    @assigner = assigner
    @story = story
    @project = @story.project

    subject = "(#{@project.name}) #{@assigner.name} assigned you to a story: #{@story.prefix_with_number}"
    mail to: @assigned_user.email, subject: subject
  end


  private
  def build_subject(description, type_name)
    prefix = "(#{@project.name})"

    if @mentioner
      "#{prefix} #{@mentioner.name} mentioned you in #{description}"
    else
      "#{prefix} Somebody mentioned you in a #{type_name}"
    end
  end

  def mentionable_details
    case @mentionable
    when Story
      [
        @mentionable.project,
        "a story: #{@mentionable.prefix_with_number}",
        "story"
      ]
    when Comment
      [
        @mentionable.story.project,
        "a comment of story: #{@mentionable.story.prefix_with_number}",
        "comment"
      ]
    else
      raise "Unsupported mentionable type: #{@mentionable.class.name}"
    end
  end
end
