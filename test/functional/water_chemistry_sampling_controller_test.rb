require File.dirname(__FILE__) + '/../test_helper'

class WaterChemistrySamplingControllerTest < ActionController::TestCase
  context "logged in as user" do
    setup do
      login
    end
    
    should "redirect to samples on edit" do
      get :edit, :aquatic_site_id => '1', :aquatic_activity_event_id => '1'
      assert_response :redirect
      assert_redirected_to :action => "samples", :aquatic_site_id => '1', :aquatic_activity_event_id => '1'
    end
    
    should "show sampling details" do            
      AquaticSite.expects(:find).with('1', { :include => :waterbody }).returns(AquaticSite.new)
      AquaticActivityEvent.expects(:find).times(2).with('1').returns(AquaticActivityEvent.new)      
      get :details, :aquatic_site_id => '1', :aquatic_activity_event_id => '1'
      assert_response :success 
    end
    
    should "list of samples" do 
      AquaticSite.expects(:find).with('1', { :include => :waterbody }).returns(AquaticSite.new)
      AquaticActivityEvent.expects(:find).with('1').returns(AquaticActivityEvent.new)      
      get :samples, :aquatic_site_id => '1', :aquatic_activity_event_id => '1'
    end
  end
  
  def login(username = 'user', password = 'password')
    @controller.expects(:current_user).at_least(0).returns(User.new(:login => username, :password => password, :password_confirmation => password))
  end    
end
