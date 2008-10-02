require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityEventControllerTest < ActionController::TestCase
  context "logged in as user" do
    setup do      
      login
      with_constraints :aquatic_site_id => 1, :aquatic_activity_cd => 1
    end     
    
    should "allow index action" do      
      get :index
      assert_response :success
      assert_template 'list'
    end
    
    should_eventually "allow new action" do
      AquaticActivityMethod.expects(:find).returns([])
      get :new, :eid => eid
      assert_response :success
      assert_template 'create_form'
    end
    
    should_eventually "allow show" do
      AquaticActivityEvent.expects(:find).with('1').returns(AquaticActivityEvent.new)
      get :show, :id => 1      
      assert_response :success
      assert_template 'show'
    end
    
    should "allow destroy" do
      aquatic_activity_event = mock('test_site') do
        expects(:destroy)
        expects(:authorized_for?).with(:action => :destroy).returns(true)
      end
      AquaticActivityEvent.expects(:find).with('1').returns(aquatic_activity_event)      
      post :destroy, :id => '1', :format => 'js'     
      assert_response :success
      assert_template 'destroy.rjs'
    end
  end
end
