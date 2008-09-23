require File.dirname(__FILE__) + '/../../test_helper'

class OandMTest < ActiveSupport::TestCase
  should_use_table 'cdOandM'
  should_use_primary_key 'OandMCd'
  
  should_have_db_column "OandM_Category",   :limit => 40, :type => :string
  should_have_db_column "OandM_Group",      :limit => 50, :type => :string
  should_have_db_column "OandM_Parameter",  :limit => 50, :type => :string
  should_have_db_column "OandM_Type",       :limit => 16, :type => :string
  should_have_db_column "OandM_ValuesInd",  :type => :boolean
  should_have_db_column "FishPassageInd",   :type => :boolean
  should_have_db_column "BankInd",          :type => :boolean
  should_have_db_column "OandM_DetailsInd", :type => :boolean
  
  should_have_instance_methods :oand_m_category, :oand_m_group, :oand_m_parameter,
    :oand_m_type, :oand_m_values_ind, :fish_passage_ind, :bank_ind, :oand_m_details_ind
  
  should_alias_attribute :oand_m_category, :category
  should_alias_attribute :oand_m_group, :group
  should_alias_attribute :oand_m_parameter, :name
  should_alias_attribute :oand_m_parameter, :parameter
  should_alias_attribute :oand_m_values_ind, :values
  should_alias_attribute :oand_m_parameter_cd, :parameter_cd
  
  should_require_attributes :oand_m_parameter
    
  context "with an existing record" do
    setup do
      o_and_m = OandM.new
      o_and_m.oand_m_parameter = 'UniqueName'
      o_and_m.save!
    end
    should_require_unique_attributes :oand_m_parameter
  end
  
  should "use OandM_Type as inheritance column" do
    assert "OandM_Type", OandM.inheritance_column
  end
  
  should "not be a subclass that needs an STI type condition" do
    assert !OandM.finder_needs_type_condition?
  end
end
