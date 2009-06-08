class UsersController < ApplicationController  
  layout 'sessions'
  
  before_filter :not_logged_in_required,   :only => [:new, :create] 
  before_filter :login_required,           :only => [:show, :edit, :update]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
  
  helper do
    def agency_dropdown(html_options = {})
      choices = Agency.active.all(:order => "Agency ASC").collect{ |agency| [agency.name, agency.id] }
      select 'user', 'agency_id', choices, {}, html_options
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
    include_javascript 'signup', { :lazy_load => true }
    @user = User.new
  end
  
  def create
    include_javascript 'signup', { :lazy_load => true }
    cookies.delete :auth_token    
    @user = User.new(params[:user])
    @user.area_of_interest_id = params[:area_of_interest]
    @user.requesting_editor_priveleges = (params[:requesting_editor_priveleges] == 'yes')

    # if the user has created an agency instead of selecting one
    @agency = Agency.new(params[:agency]) if params[:agency]
    @user.agency = @agency if @agency

    @user.save!
    flash[:notice] = :new_account_notice.l
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid => exc
    logger.error exc.message
    flash[:error] = :create_account_error.l
    render :action => 'new'
  end
  
  def page_title
    :users_page_title.l_with_args({ :location => current_location })
  end
  
  def current_location
    case action_name.to_sym
    when :new, :create then :signup_location.l
    when :edit         then :profile_location.l
    else action_name
    end
  end
  
  def edit
    @user = current_user
    previous_location = request.env["HTTP_REFERER"]
    unless previous_location == edit_user_path(@user) || previous_location == '/users/1'
      session[:previous_location] = previous_location
    end
    render :layout => 'application'
  end
  
  def update
    @user = User.find(current_user)
    
    attr_diff = {}
    params[:user].each do |attr, value|
      next if value.to_s.blank? #ignore blank values
      attr_diff[attr] = value if @user.attributes[attr] != value
    end
    if params[:requesting_editor_priveleges] == 'yes' && !@user.editor?
      attr_diff[:requesting_editor_priveleges] = true unless @user.requesting_editor_priveleges?
    end
    unless params[:area_of_interest].to_s.blank?
      attr_diff[:area_of_interest_id] = params[:area_of_interest] if @user.area_of_interest_id != params[:area_of_interest]
    end
    # doesn't matter if they set an AOI above, if 'remove area of interest' is checked, remove it
    if params[:remove_area_of_interest]
      attr_diff[:area_of_interest_id] = nil
    end
            
    if @user.update_attributes(attr_diff)
      flash[:notice] = "#{:user_profile_updated_notice.l} <a href=\"#{session[:previous_location]}\">#{:return_to_application.l}</a>"
    else
      flash[:error]  = :update_profile_error.l
    end
    render :layout => 'application', :action => 'edit'
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = :user_account_disabled_notice.l
    else
      flash[:error] = :user_account_could_not_be_disabled_error.l
    end
    redirect_to :action => 'index'
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = :user_account_enabled_notice.l
    else
      flash[:error] = :user_account_could_not_be_enabled_error.l
    end
    redirect_to :action => 'index'
  end
end
