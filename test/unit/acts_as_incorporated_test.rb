require File.dirname(__FILE__) + '/../test_helper'

class ActsAsIncorporatedTest < ActiveSupport::TestCase  
  def setup
    ActiveRecord::Schema.define() do   
      create_table :acts_as_incorporated do |t|
        t.string  :name
        t.boolean :incorporatedind
        t.boolean :other_incorporated_column 
      end    
      create_table :almost_acts_as_incorporated do |t|
        t.string  :name
        t.string  :incorporatedind
      end    
      create_table :never_acts_as_incorporated do |t|
        t.string  :name
      end
    end
  end
  
  def teardown
    ActiveRecord::Schema.define() do 
      drop_table :acts_as_incorporated 
      drop_table :almost_acts_as_incorporated 
      drop_table :never_acts_as_incorporated 
    end
  end
  
  def create_acts_as_incorporated_model(options = {})
    Class.new(ActiveRecord::Base) do
      set_table_name options.delete(:table) { |default| :acts_as_incorporated }
      acts_as_incorporated options
    end  
  end  
  
  should "ignore multiple includes" do
    model = create_acts_as_incorporated_model
    assert model.acts_as_incorporated?
    model.class_eval { acts_as_incorporated }
    assert model.acts_as_incorporated?
  end

  should "give correct class status" do
    assert create_acts_as_incorporated_model.acts_as_incorporated?
    assert !Class.new(ActiveRecord::Base).acts_as_incorporated? 
  end
  
  should "raise error if the incorporatedind column is not present" do
    assert_raise DataWarehouse::ActsAsIncorporated::CannotBeIncorporatedError do
      create_acts_as_incorporated_model :table => :never_acts_as_incorporated
    end
  end
  
  should "raise error if the incorporatedind column is not a boolean type" do
    assert_raise DataWarehouse::ActsAsIncorporated::CannotBeIncorporatedError do
      create_acts_as_incorporated_model :table => :almost_acts_as_incorporated
    end
  end
  
  should "allow incorporated_column to be set by user" do
    model = create_acts_as_incorporated_model :incorporated_column => 'other_incorporated_column'
    assert_equal 'other_incorporated_column', model.incorporated_column
  end
  
  context "with an existing incorporated record" do
    setup do
      @model = create_acts_as_incorporated_model
      @record = @model.create(:name => 'incorporated record', :incorporatedind => true)
      assert @record.incorporated?
    end
    
    should "raise error when attempting to destroy" do
      assert_raise(DataWarehouse::ActsAsIncorporated::RecordIsIncorporated) { @record.destroy }
    end
  end
end
