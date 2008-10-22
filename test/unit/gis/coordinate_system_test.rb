require File.dirname(__FILE__) + '/../../test_helper'

class CoordinateSystemTest < ActiveSupport::TestCase
  should_use_table :coordinate_systems
  should_use_primary_key :epsg
  
  should_have_db_column :name, :type => :string, :limit => 100
  should_have_db_column :display_name, :type => :string, :limit => 40
  
  should_have_and_belong_to_many :coordinate_sources
end
