require File.dirname(__FILE__) + '/../../test_helper'

class UnitOfMeasureTest < ActiveSupport::TestCase
  should_use_table 'cdUnitofMeasure'
  should_use_primary_key 'UnitofMeasureCd'
  
  should_have_db_column 'UnitofMeasure', :type => :string, :limit => 50
  should_have_db_column 'UnitofMeasureAbv', :type => :string, :limit => 10
  
  should_have_instance_methods :unitof_measure, :unitof_measure_abv
  
  should_alias_attribute :unitof_measure, :name
  should_alias_attribute :unitof_measure_abv, :abbrev
  
  should_have_and_belong_to_many :measurements
end
