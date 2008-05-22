require File.dirname(__FILE__) + '/../test_helper'

class ActsAsImportableTest < ActiveSupport::TestCase     
  def create_acts_as_importable_model(options = {})
    table_name = options.has_key?(:table_name) ? options.delete(:table_name) : 'defaultTableName'
    Class.new(ActiveRecord::Base) do
      acts_as_importable table_name, options
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
  
  should "allow primary key option to be set" do
    model = create_acts_as_importable_model :primary_key => 'myPrimaryKey'
    assert_equal 'myPrimaryKey', model.import_primary_key
  end
  
  should_eventually "recognize transformation blocks for custom attributes" do
    
  end
  
  should_eventually "guess correct attribute mapping when attribute transformation block isn't present" do
    
  end
  
  context "when guessing the primary key" do    
    should "guess 'AquaticSiteId' when table name is like 'tblAquaticSite'" do
      model = create_acts_as_importable_model :table_name => 'tblAquaticSite'
      assert_equal 'AquaticSiteId', model.import_primary_key
    end
    
    should "guess 'AgencyCd' when table name is like 'cdAgency'" do 
      model = create_acts_as_importable_model :table_name => 'cdAgency'
      assert_equal 'AgencyCd', model.import_primary_key
    end
    
    should "guess 'Id' when table name doesn't follow data warehouse conventions" do
      ['cd', 'tbl', 'other'].each do |table_name|
        model = create_acts_as_importable_model :table_name => table_name
        assert_equal 'Id', model.import_primary_key
      end
    end
  end
end
