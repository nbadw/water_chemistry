require File.dirname(__FILE__) + '/../test_helper'

class CdAgencyTest < ActiveSupport::TestCase
  should_require_attributes :name
  should_have_many :users #, :aquatic_site_usages
#  
#  should "be using code as the primary key" do
#    assert_equal "code", Agency.primary_key    
#  end
#  
#  should "have the primary key defined as type :string" do
#    primary_key_col = nil
#    Agency.columns.each { |column| primary_key_col = column if column.primary }
#    assert_equal Agency.primary_key, primary_key_col.name
#    assert_equal :string, primary_key_col.type
#  end
#  
#  context "given an unsaved agency" do
#    setup do
#      @agency = Agency.spawn 
#      assert @agency.id == @agency.code
#    end
#    
#    should "treat agency.id the same as agency.code" do   
#      @agency.id = 'new id'
#      assert @agency.id == @agency.code
#      @agency.code = 'new agency code'
#      assert @agency.id == @agency.code
#    end
#  end
end
