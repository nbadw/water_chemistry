require File.dirname(__FILE__) + '/../test_helper'

class ActsAsImportableTest < ActiveSupport::TestCase     
  def create_acts_as_importable_model(options = {})
    Class.new(ActiveRecord::Base) do
      acts_as_importable 
    end  
  end  
  
  should "ignore multiple includes" do
    model = create_acts_as_importable_model
    assert model.acts_as_importable?
    model.class_eval { acts_as_importable }
    assert model.acts_as_importable?
  end

  should "give correct class status" do
    assert create_acts_as_importable_model.acts_as_importable?
    assert !Class.new(ActiveRecord::Base).acts_as_importable? 
  end
end
