require File.dirname(__FILE__) + '/../test_helper'

class WaterChemistrySamplingControllerTest < ActionController::TestCase
  context "logged in as user" do
    setup do
      login
    end
    
    should_eventually "list samples" do
      AquaticSite.expects(:find).with('1', { :include => [:waterbody, :gmap_location] }).returns(AquaticSite.new)
      AquaticActivityEvent.expects(:find).with('1').returns(AquaticActivityEvent.new)      
      get :samples, :aquatic_site_id => '1', :aquatic_activity_event_id => '1'
    end
  end
  
  def login(username = 'user', password = 'password')
    @controller.expects(:current_user).at_least(0).returns(User.new(:login => username, :password => password, :password_confirmation => password))
  end    
end
