class UsersController < ApplicationController  
  layout 'sessions'
  
  before_filter :not_logged_in_required,   :only => [:new, :create] 
  before_filter :login_required,           :only => [:show, :edit, :update]

  # only used to allow validations to be translated properly
  active_scaffold :user do |config|
    config.actions = [:create]
    config.columns = [:name, :login, :email, :password, :password_confirmation, :agency, :area_of_interest, :language, :agency, :agency_cd]
    config.columns[:name].label                  = :users_form_name_field
    config.columns[:login].label                 = :users_form_login_field
    config.columns[:email].label                 = :users_form_email_field
    config.columns[:password].label              = :new_users_form_password_field
    config.columns[:password_confirmation].label = :new_users_form_password_confirmation_field
    config.columns[:language].label              = :users_form_preferred_language_field
    config.columns[:agency].label = :new_users_form_create_agency_agency_field
    config.columns[:agency_cd].label = :new_users_form_create_agency_agency_cd_field
  end
  
  helper do
    def agency_dropdown(html_options = {})
      choices = Agency.active.all(:order => "Agency ASC").collect{ |agency| [agency.name, agency.id] }
      select 'user', 'agency_id', choices, {}, html_options
    end
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
    when :new,  :create then :signup_location.l
    when :edit, :update then :profile_location.l
    else action_name
    end
  end
  
  def edit
    @user = current_user
    previous_location = request.env["HTTP_REFERER"]
    unless previous_location.match(/#{edit_user_path(@user)}/) || previous_location.match(/\/users\/\d+/)
      session[:previous_location] = previous_location
    end
    render :layout => 'application'
  end
  
  def update
    @user = User.find(current_user)
    updated = false
    previous_language = @user.language

    # update any attribute values that have changed
    params[:user].each do |attr, value|
      unless value.to_s.blank? || value == @user.send(attr)
        @user.send("#{attr}=", value)
        updated = true
      end
    end

    # have editor priveleges been requested?
    if params[:requesting_editor_priveleges] == 'yes'
      unless @user.editor? && @user.requesting_editor_priveleges?
        @user.requesting_editor_priveleges = true
        updated = true
      end
    end

    # has an area of interest been specified
    unless params[:area_of_interest].to_s.blank? || @user.area_of_interest_id == params[:area_of_interest]
      @user.area_of_interest_id = params[:area_of_interest]
      updated = true
    end

    # doesn't matter if they set an AOI above, if 'remove area of interest' is checked, remove it
    if params[:remove_area_of_interest]
      @user.area_of_interest_id = nil
      updated = true
    end

    # the language might have been changed so we'll have to set the locale if so
    # since the flash message will now need to be in the appropriate language
    unless previous_language == @user.language
      logger.debug "[globalite] updating language for user profile: #{@user.language}"
      Locale.code = "#{@user.language}-*"
    end
            
    if updated
      if  @user.save
        flash[:notice] = "#{:user_profile_updated_notice.l} <a href=\"#{session[:previous_location]}\">#{:return_to_application.l}</a>"
      else
        flash[:error]  = :update_profile_error.l
      end
    end
    
    render :layout => 'application', :action => 'edit'
  end
end
