require File.dirname(__FILE__) + '/../test_helper'
require 'data_warehouse'

class DwModel < ActiveRecord::Base
  acts_as_data_warehouse_model
end

class OriginalDwModel < ActiveRecord::Base  
end

class NonDwModel < ActiveRecord::Base
end

class DataWarehouseTest < ActiveSupport::TestCase  
  should "ignore multiple includes" do    
    DwModel.class_eval { acts_as_data_warehouse_model }
    assert DwModel.data_warehouse_model?
  end
  
  should "give data warehouse status" do    
    assert DwModel.data_warehouse_model?
    assert !NonDwModel.data_warehouse_model?
  end
  
  
end
