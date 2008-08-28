require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase
  should_use_table "cdAgency"
  should_use_primary_key "AgencyCd", :type => :string, :limit => 5
  
  should_have_db_column "Agency", :limit => 60, :type => :string
  should_have_db_column "AgencyType", :limit => 4, :type => :string
  should_have_db_column "DataRulesInd", :limit => 1, :type => :string
  
  should_have_instance_methods :agency, :agency_cd, :agency_type, :data_rules_ind
  
  should_alias_attribute :agency, :name
  should_alias_attribute :agency_cd, :code
  
  should "create/read/update/delete" do
    agency = Agency.spawn
    assert agency.save
    db_record = Agency.find(agency.id)
    assert_equal agency.id, db_record.id
    agency.name = agency.name.to_s.reverse
    assert agency.save
    assert agency.destroy
    assert !Agency.exists?(agency.id)
  end
end
