require File.dirname(__FILE__) + '/../../test_helper'

class ObservableValueTest < ActiveSupport::TestCase
  should_use_table 'cdOandMValues'
  should_use_primary_key 'OandMValuesCd'
  
  should_have_db_column 'OandMCd', :type => :integer
  should_have_db_column 'Value', :type => :string, :limit => 20  
  
  should_belong_to :observation
  
  should_have_instance_methods :value
end
