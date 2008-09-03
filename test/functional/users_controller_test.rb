require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  should_eventually "set last login time on successful login"
  should_eventually "display a area of interest input"  
  
  def test_should_allow_signup    
    user = mock
    user.expects(:save!)
    User.expects(:new).returns(user)
    post :create, :user => user_params
    assert_response :redirect
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    user = User.new
    user.expects(:save!).raises(ActiveRecord::RecordInvalid, user)
    User.expects(:new).returns(user)
    post :create
  end
   
  def test_should_sign_up_user_with_activation_code
    create_user
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  # XXX: this doesn't seems like the right place for this test, maybe the accounts controller instead?
  #  def test_should_activate_user
  #    assert_nil User.authenticate('aaron', 'test')
  #    get :show, :activation_code => users(:aaron).activation_code
  #    assert_redirected_to '/login'
  #    assert_not_nil flash[:notice]
  #    assert_equal users(:aaron), User.authenticate('aaron', 'test')
  #  end
  
  def test_should_not_activate_user_without_key
    get :show
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :show, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  protected
  def user_params(options = {})
    { :login => 'colin', :email => 'test@email.com', :agency_id => '1',
      :password => 'password', :password_confirmation => 'password' }.merge(options)
  end
    
  def create_user(options = {})
    u = User.spawn
    post :create, :user => { :login => u.login, :email => u.email, :agency_id => u.agency.id,
      :password => u.password, :password_confirmation => u.password_confirmation }.merge(options)
  end
end
