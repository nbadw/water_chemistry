require File.dirname(__FILE__) + '/../test_helper'

#class NonDwModel < ActiveRecord::Base; end
#class DwModel < ActiveRecord::Base
#  acts_as_incorporated
#  acts_as_exportable
#  acts_as_importable
#end

class DataWarehouseTest < ActiveSupport::TestCase  
  context "when guessing target column attribute" do    
    should_eventually "be able to guess correctly when a prefix is present" do
      #DwModel.new.guess_target_attribute_column('column', 'TablePrefixColumn')
    end
    
    should_eventually "be able to accurately guess when underscores are present" do
      #'underscored_column', 'underscoredcolumn'
    end
  end  
  
#  context "when model acts as incorporated" do    
#    should "ignore multiple includes" do    
#      assert DwModel.acts_as_incorporated?
#      DwModel.class_eval { acts_as_incorporated }
#      assert DwModel.acts_as_incorporated?
#    end
#
#    should "give correct class status" do    
#      assert DwModel.acts_as_incorporated?
#      assert !NonDwModel.acts_as_incorporated? 
#    end
#  end
#  
#  context "when model acts as exportable" do    
#    should "ignore multiple includes" do    
#      assert DwModel.acts_as_exportable?
#      DwModel.class_eval { acts_as_exportable }
#      assert DwModel.acts_as_exportable?
#    end
#
#    should "give correct class status" do    
#      assert DwModel.acts_as_exportable?
#      assert !NonDwModel.acts_as_exportable? 
#    end
#  end  
  
end
