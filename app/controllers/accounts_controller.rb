class AccountsController < ApplicationController
  layout 'application'
  before_filter :login_required, :except => :show
  before_filter :not_logged_in_required, :only => :show
  
  # Activate action
  def show
    # Uncomment and change paths to have user logged in after activation - not recommended
    #self.current_user = User.find_and_activate!(params[:id])
    User.find_and_activate!(params[:id])
    flash[:notice] = :account_activated_notice.l
    redirect_to login_path
  rescue User::ArgumentError
    flash[:error] = :activation_code_not_found_error.l
    redirect_to new_user_path 
  rescue User::ActivationCodeNotFound
    flash[:error] = :activation_code_not_found_error.l
    redirect_to new_user_path
  rescue User::AlreadyActivated
    flash[:notice] = :account_already_activated_notice.l
    redirect_to login_path
  end
  
  def edit
  end
  
  # Change password action  
  def update
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]        
        if current_user.save
          flash[:notice] = :password_updated_notice.l
          redirect_to root_path 
        else
          flash[:error] = :update_password_error.l
          render :action => 'edit'
        end
      else
        flash[:error] = :password_confimation_error.l
        @old_password = params[:old_password]
        render :action => 'edit'      
      end
    else
      flash[:error] = :old_password_incorrect_error.l
      render :action => 'edit'
    end 
  end
end
