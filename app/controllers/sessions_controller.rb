# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController    
  before_filter :login_required,         :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  # render new.rhtml
  def new
    @page_title = :login_page_title.l
  end
  
  def create
    password_authentication(params[:username], params[:password])
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = :logout_notice.l
    redirect_to :action => 'new', :lang => self.current_user.language
  end

  def reset
    reset_session
  end
  
  protected  
  # Updated 2/20/08
  def password_authentication(login, password)
    user = User.authenticate(login, password)
    if user == nil
      failed_login(:incorrect_username_or_password.l)
    elsif user.activated_at.blank?  
      failed_login(:account_inactive.l)
    elsif user.enabled == false
      failed_login(:account_disabled.l)
    else
      self.current_user = user
      successful_login
    end
  end
  
  private  
  def failed_login(message)
    flash.now[:error] = message
    render :action => 'new'
  end
  
  def successful_login
    # record login time
    current_user.last_login = DateTime.now
    current_user.save
    
    # clear the previous session variables
    # XXX: i don't like this session stuff...
    session[:search] = ''
    session[:filter_area_of_interest] = true
    
    # set remember me cookie
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    
    flash[:notice] = :login_notice.l
    return_to = session[:return_to]
    if return_to.nil?
      redirect_to root_path
    else
      redirect_to return_to
    end
  end
end
