require File.dirname(__FILE__) + '/../../test_helper'

class AquaticActivityTest < ActiveSupport::TestCase
  should_use_table "cdAquaticActivity"
  should_use_primary_key "AquaticActivityCd"
  
  should_have_db_column "AquaticActivity", :limit => 50, :type => :string
  should_have_db_column "AquaticActivityCategory", :limit => 30, :type => :string
  should_have_db_column "Duration", :limit => 20, :type => :string
  
  should_have_instance_methods :aquatic_activity, :aquatic_activity_category, :duration
    
  should_have_many :aquatic_activity_events
                     
  should_alias_attribute :aquatic_activity, :name
  should_alias_attribute :aquatic_activity_category, :category
end
