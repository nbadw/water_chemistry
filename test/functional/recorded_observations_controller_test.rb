require File.dirname(__FILE__) + '/../test_helper'

class RecordedObservationsControllerTest < ActionController::TestCase
  context "logged in as user" do
    context "with contraints" do
      setup do        
        login
        with_constraints :aquatic_activity_event_id => '1'
      end
    
      should "allow new action" do
        Observation.expects(:all).returns([Observation.spawn(:group => 'Test1'), Observation.spawn(:group => 'Test2')])

        get_with_eid :new      
        
        assert_response :success
        assert_template 'create_form'
      end   
    end      
  end
end
