require File.dirname(__FILE__) + '/../test_helper'

class OandMTest < ActiveSupport::TestCase
  should_use_table 'cdOandM'
  should_use_primary_key 'OandMCd'
  
  should_have_db_column "OandM_Category",  :limit => 40, :type => :string
  should_have_db_column "OandM_Group",     :limit => 50, :type => :string
  should_have_db_column "OandM_Parameter", :limit => 50, :type => :string
  should_have_db_column "OandM_Type",      :limit => 16, :type => :string
  should_have_db_column "OandM_ValuesInd", :type => :boolean
  
  should_have_instance_methods :oand_m_category, :oand_m_group, :oand_m_parameter,
    :oand_m_type, :oand_m_values_ind
  
  should_alias_attribute :oand_m_category, :category
  should_alias_attribute :oand_m_group, :group
  should_alias_attribute :oand_m_parameter, :parameter
  should_alias_attribute :oand_m_values_ind, :values
end
