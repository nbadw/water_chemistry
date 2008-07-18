require File.dirname(__FILE__) + '/../test_helper'

class SiteMeasurementControllerTest < ActionController::TestCase
  context "on POST to :new" do
    setup do
      login_as :admin
      post :new
    end
    
    should_assign_to :measurements
  end
end
