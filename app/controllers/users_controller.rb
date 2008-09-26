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
    @user.area_of_interest_id = params[:area_of_interest]
    @user.save!
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid => exc
    logger.error exc.message
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end
    
  def edit
    @user = current_user
    previous_location = request.env["HTTP_REFERER"]
    unless previous_location == edit_user_path(@user) || previous_location == '/users/1'
      session[:previous_location] = previous_location
    end
    render :layout => 'profile'
  end
  
  def update
    @user = User.find(current_user)
    
    attr_diff = {}
    params[:user].each do |attr, value|
      next if value.to_s.blank? #ignore blank values
      attr_diff[attr] = value if @user.attributes[attr] != value
    end
    unless params[:area_of_interest].to_s.blank?
      attr_diff[:area_of_interest_id] = params[:area_of_interest] if @user.area_of_interest_id != params[:area_of_interest]
    end
            
    if @user.update_attributes(attr_diff)
      flash[:notice] = 'User profile updated successfully. <a href="' + session[:previous_location] + '">Click here to return to application.</a>'
    else
      flash[:error]  = "Profile changes could not be saved."
    end
    render :layout => 'profile', :action => 'edit'
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
