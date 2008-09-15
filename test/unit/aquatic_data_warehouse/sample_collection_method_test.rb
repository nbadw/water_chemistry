require File.dirname(__FILE__) + '/../../test_helper'

class SampleCollectionMethodTest < ActiveSupport::TestCase
  should_use_table "cdSampleCollectionMethod"
  should_use_primary_key "SampleMethodCd"
  
  should_have_db_column "SampleMethod", :type => :string, :limit => 30
  should_have_db_column "Description", :type => :string, :limit => 255
  
  should_have_instance_methods :sample_method_cd, :sample_method, :description
  
  should_have_many :samples
end
