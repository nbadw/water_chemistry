require File.dirname(__FILE__) + '/../test_helper'
require 'data_warehouse'

begin; ActiveRecord::Schema.drop_table 'models'; rescue; end
begin; ActiveRecord::Schema.drop_table 'original_models'; rescue; end
begin; ActiveRecord::Schema.drop_table 'prefixed_models'; rescue; end
begin; ActiveRecord::Schema.drop_table 'original_prefixed_models'; rescue; end 

ActiveRecord::Schema.create_table 'models' do |t|
  t.string    'name'
  t.string    'description'
  t.timestamp 'incorporated_at'
end

ActiveRecord::Schema.create_table 'original_models' do |t|
  t.string    'Name'
  t.string    'Description'
  t.timestamp 'IncorporatedInd'
end

ActiveRecord::Schema.create_table 'prefixed_models' do |t|
  t.string    'name'
  t.string    'description'
  t.timestamp 'incorporated_at'
end

ActiveRecord::Schema.create_table 'original_prefixed_models' do |t|
  t.string    'TablePrefixName'
  t.string    'TablePrefixDescription'
  t.timestamp 'IncorporatedInd'
end

class Model < ActiveRecord::Base
  acts_as_incorporated 
end

class PrefixedModel < ActiveRecord::Base
  acts_as_incorporated :export_table_prefix => 'TablePrefix'
end

class OriginalModel < ActiveRecord::Base; end
class OriginalPrefixedModel < ActiveRecord::Base; end
class NonIncorporatedModel < ActiveRecord::Base; end

class DataWarehouseTest < ActiveSupport::TestCase  
  should "ignore multiple includes" do    
    Model.class_eval { acts_as_incorporated }
    assert Model.acts_as_incorporated?
  end
  
  should "give acts as incorporated status" do    
    assert Model.acts_as_incorporated?
    assert NonIncorporatedModel.acts_as_incorporated? 
  end
  
  context "with as existing record" do
    setup { @model = Model.generate }
    
    should "give record incorporated status" do
      assert_equal false, @model.incorporated? 
      @model.export_to_data_warehouse
      assert @model.incorporated?
    end
  end
end
