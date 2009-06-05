class PasswordsController < ApplicationController
  layout 'sessions'
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  # Enter email address to recover password 
  def new
    @page_title = :new_page_title.l
  end
  
  # Forgot password action
  def create    
    return unless request.post?
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save      
      flash[:notice] = :password_reset_link_sent_notice.l
      redirect_to login_path
    else
      flash[:error] = :user_not_found_error.l
      render :action => 'new'
    end  
  end
  
  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a user in the database
  # Then if everything checks out, shows the password reset fields
  def edit
    if params[:id].nil?
      render :action => 'new'
      return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
  rescue
    logger.error "Invalid Reset Code entered."
    flash[:error] = :invalid_password_reset_code_error.l
    redirect_to login_url
  end
  
  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update
    if params[:id].nil?
      render :action => 'new'
      return
    end

    if params[:password].blank?
      flash[:error] = :password_blank_error.l
      render :action => 'edit', :id => params[:id]
      return
    end
    
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]

    raise if @user.nil?
    return if @user unless params[:password]

    if (params[:password] == params[:password_confirmation])
      @user.password_confirmation = params[:password_confirmation]
      @user.password = params[:password]
      @user.reset_password 
      if @user.save
        flash[:notice] = :password_reset_notice.l
      else
        flash[:error]  = :invalid_password_reset_error.l
      end
    else
      flash[:error] = :password_and_confirmation_are_different_error.l
      render :action => 'edit', :id => params[:id]
      return
    end

    redirect_to login_path
  rescue
    logger.error "Invalid Reset Code entered"
    flash[:error] = :invalid_password_reset_code_error.l
    redirect_to login_url
  end
end
