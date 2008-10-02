require File.dirname(__FILE__) + '/../../test_helper'

class CoordinateSourceTest < ActiveSupport::TestCase
  should_use_table :coordinate_sources
  should_use_primary_key :id
  
  should_have_db_column :name, :type => :string, :limit => 30
end
