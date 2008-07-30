require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityTest < ActiveSupport::TestCase
  should_use_table :cdaquaticactivity
  should_use_primary_key :aquaticactivitycd
  
  should_have_many :aquatic_activity_events
                     
  should_have_db_column  :aquaticactivity, :type => :string, :limit => 50
  should_alias_attribute :aquaticactivity, :name
  
  should_have_db_column  :aquaticactivitycategory, :type => :string, :limit => 30
  should_alias_attribute :aquaticactivitycategory, :category
  
  should_have_db_column :duration, :type => :string, :limit => 20
  
  should_define_timestamps  
end
