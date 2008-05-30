require File.dirname(__FILE__) + '/../test_helper'

class CdAgencyTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :users #, :aquatic_site_usages
  
  should "be using code as the primary key" do
    assert_equal "agencycd", CdAgency.primary_key    
  end
  
  should "have the primary key defined as type :string" do
    primary_key_col = nil
    CdAgency.columns.each { |column| primary_key_col = column if column.primary }
    assert_equal CdAgency.primary_key, primary_key_col.name
    assert_equal :string, primary_key_col.type
  end
  
  context "given an unsaved agency" do
    setup do
      @agency = CdAgency.spawn 
      assert @agency.id == @agency.code
    end
    
    should "treat agency.id the same as agency.code" do   
      @agency.id = 'DFO'
      assert @agency.id == @agency.code
      @agency.code = 'ADW'
      assert @agency.id == @agency.code
    end
  end
end
