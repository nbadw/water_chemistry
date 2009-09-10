class UserMailer < ApplicationMailer  
  def signup_notification(user)
    setup_email(user)
    subject :signup_notification_subject.l
  end
  
  def request_for_editor_priveleges(user)
    setup_email(user)
    administrators = User.administrators
    recipients administrators.collect { |admin| admin.email }
    reply_to   nil
    subject    :request_for_editor_priveleges_subject.l_with_args({ :name => user.name })
  end
  
  def editor_priveleges_granted(user)
    setup_email(user)
    subject :editor_priveleges_granted_subject.l
  end
  
  def forgot_password(user)
    setup_email(user)
    subject :forgot_password_subject.l
  end
  
  def reset_password(user)
    setup_email(user)
    subject :reset_password_subject.l
  end
  
  protected
  def setup_email(user)
    recipients user.email
    from       :mail_from.l
    reply_to   "nb.aquatic.datawarehouse@gmail.com"
    sent_on    Time.now
    template   "#{@template}_#{user.language}"
    body[:user] = user
  end
end
