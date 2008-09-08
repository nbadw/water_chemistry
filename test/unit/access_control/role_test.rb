require File.dirname(__FILE__) + '/../../test_helper'

class RoleTest < ActiveSupport::TestCase
  should_require_attributes :rolename
  
  should_have_many :permissions
  should_have_many :users, :through => :permissions
  
  context "given an existing record" do
    setup do 
      @role = Role.generate
    end
    
    should_require_unique_attributes :rolename
  end  
end
