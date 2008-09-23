class UsersController < ApplicationController  
  layout 'sessions'
  
  before_filter :not_logged_in_required,   :only => [:new, :create] 
  before_filter :login_required,           :only => [:show, :edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  helper do
    def agency_dropdown
      options = Agency.find(:all, :order => "#{Agency.column_for_attribute(:agency).name} ASC").collect{ |agency| [agency.name, agency.id] }
      select 'user', 'agency_id', options      
    end
  end
  
  def index
    @users = User.find(:all)
  end
  
  #This show action only allows users to view their own profile
  def show
    @user = current_user
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def create
    cookies.delete :auth_token    
    @user = User.new(params[:user])
    @user.save!
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid => exc
    logger.error exc.message
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end
  
  def profile
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = "User updated"
      redirect_to :action => 'show', :id => current_user
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to :action => 'index'
  end
end
