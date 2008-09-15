require File.dirname(__FILE__) + '/../test_helper'

class SamplesControllerTest < ActionController::TestCase
  context "logged in as user" do
    setup do
      login
    end
  end
  
  def login(username = 'user', password = 'password')
    @controller.expects(:current_user).at_least(0).returns(User.new(:login => username, :password => password, :password_confirmation => password))
  end    
end
