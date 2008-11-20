class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
    UserMailer.deliver_request_for_editor_priveleges(user) if user.requesting_editor_priveleges?
  end

  def after_save(user)   
    UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
    UserMailer.deliver_reset_password(user) if user.recently_reset_password?
    if user.editor_priveleges_granted?
      UserMailer.deliver_editor_priveleges_granted(user) 
    end
  end
end
