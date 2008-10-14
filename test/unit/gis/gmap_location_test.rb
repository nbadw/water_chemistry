require File.dirname(__FILE__) + '/../../test_helper'

class GmapLocationTest < ActiveSupport::TestCase
  should_use_table :gmap_locations
  should_use_primary_key :id
  
  should_have_db_column :locatable_id, :type => :integer
  should_have_db_column :locatable_type, :type => :string
  should_have_db_column :latitude, :type => :decimal, :precision => 15, :scale => 10
  should_have_db_column :longitude, :type => :decimal
  
  should_belong_to :locatable
end
