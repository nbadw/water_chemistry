class UserMailer < ActionMailer::Base
  default_url_options[:host] = 'cri.nbwaters.unb.ca'
  default_url_options[:port] = 3000
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'  
    @body[:url]  = activate_url(user.activation_code)
  end
    
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = login_url
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'Please reset your password'
    @body[:url]  = reset_password_url(user.password_reset_code)
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset'
    @body[:url]  = login_url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@dataentry.com"
      @subject     = "NB Aquatic Data Warehouse: "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
