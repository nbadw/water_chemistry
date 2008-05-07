require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase  
  should_require_attributes :name, :code  
  should_have_many :users
  
  context "given an existing record" do
    setup do
      @agency = Agency.generate
    end
    
    should_require_unique_attributes :code
  end
end
