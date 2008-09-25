class UserMailer < ApplicationMailer  
  def signup_notification(user)
    setup_email(user)
    subject "NB Aquatic Data Warehouse Account Information"  
  end
  
  def forgot_password(user)
    setup_email(user)
    subject 'Password reset requested'
  end
  
  def reset_password(user)
    setup_email(user)
    subject 'Your password has been reset'
  end
  
  protected
  def setup_email(user)
    recipients user.email
    from       "NB Aquatic Data Warehouse"
    reply_to   "ccasey@unb.ca"
    sent_on    Time.now
    body[:user] = user
  end
end
