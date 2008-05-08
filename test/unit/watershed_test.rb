require File.dirname(__FILE__) + '/../test_helper'

class WatershedTest < ActiveSupport::TestCase  
  should_have_many :waterbodies
  
  should "be using drainage_code as the primary key" do
    assert_equal "drainage_code", Watershed.primary_key    
  end
  
  should "have the primary key defined as type :string" do
    primary_key_col = nil
    Watershed.columns.each { |column| primary_key_col = column if column.primary }
    assert_equal Watershed.primary_key, primary_key_col.name
    assert_equal :string, primary_key_col.type
  end
  
  context "given an unsaved watershed" do
    setup do
      @watershed = Watershed.spawn 
      assert @watershed.id == @watershed.drainage_code
    end
    
    should "treat watershed.id the same as watershed.drainage_code" do   
      @watershed.id = 'new id'
      assert @watershed.id == @watershed.drainage_code
      @watershed.drainage_code = 'new drainage code'
      assert @watershed.id == @watershed.drainage_code
    end
    
    should "allow values in the format (XX-XX-XX-XX-XX-XX)" do
      @watershed.drainage_code = '01-02-03-04-05-06'
      assert @watershed.valid?
    end
    
    should "not allow values that don't match the format (XX-XX-XX-XX-XX-XX)" do
      bad_values = [1, '01', '001-002-003-004-005-006', '01 02 03 04 05 06', 'AA-BB-CC-DD-EE-FF']
      bad_values.each do |bad_value|
        @watershed.drainage_code = bad_value
        assert !@watershed.valid?
      end
    end
  end
end
