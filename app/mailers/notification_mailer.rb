class NotificationMailer < ApplicationMailer
  def user_mentioned(mentioned_user, mentioner, mentionable)
    @mentioned_user = mentioned_user
    @mentioner = mentioner
    @mentionable = mentionable

    if @mentioner.nil?
      subject = "Somebody mentioned you in a #{@mentionable.model_name.human.downcase}"
    else
      subject = "#{@mentioner.name} mentioned you in a #{@mentionable.model_name.human.downcase}"
    end
    mail to: @mentioned_user.email, subject: subject
  end
end
