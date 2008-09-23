require File.dirname(__FILE__) + '/../../test_helper'

class QualifierTest < ActiveSupport::TestCase
  should_use_table "cdWaterChemistryQualifier"
  should_use_primary_key "QualifierCd", :type => :string, :limit => 4
  
  should_have_db_column "Qualifier", :limit => 100, :type => :string  
  
  should_have_instance_methods :qualifier_cd, :qualifier
  
  should_alias_attribute :qualifier, :name
end
