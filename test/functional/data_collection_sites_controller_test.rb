require File.dirname(__FILE__) + '/../test_helper'

class DataCollectionSitesControllerTest < ActionController::TestCase
  context "logged in as user" do
    setup do
      login
    end
    
    should_eventually "do something on coordinate source change"
    should_eventually "perform a watershed search"    
    
    should "allow search action" do
      get :update_table, :search => 'test'
      assert_response :success
      assert_template '_list'
    end
    
    should "allow index action" do      
      get :index
      assert_response :success
      assert_template 'list'
    end
    
    should "allow new action" do
      get :new
      assert_response :success
      assert_template 'create_form'
    end
    
    should "allow show" do
      AquaticSite.expects(:find).with('1').returns(AquaticSite.new)
      get :show, :id => 1      
      assert_response :success
      assert_template 'show'
    end
    
    should "allow destroy" do
      aquatic_site = mock('test_site') do
        expects(:destroy)
        expects(:authorized_for?).with(:action => :destroy).returns(true)
      end
      AquaticSite.expects(:find).with('1').returns(aquatic_site)      
      post :destroy, :id => '1', :format => 'js'     
      assert_response :success
      assert_template 'destroy.rjs'
    end
  end
  
  def login(username = 'user', password = 'password')
    @controller.expects(:current_user).at_least(0).returns(User.new(:login => username, :password => password, :password_confirmation => password))
  end
  
  def with_constraints(constraints = {}) 
    @request.session["as:#{eid}"] = { :constraints => constraints }
  end
  
  def eid
    self.class.name
  end
  
  def test_create
    
  end
  
  def test_show
    
  end
  
  def test_edit
    
  end
  
  def test_update
    
  end
  
  def test_delete
    
  end
end
