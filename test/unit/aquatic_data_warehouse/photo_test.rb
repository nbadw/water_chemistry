require File.dirname(__FILE__) + '/../../test_helper'

class PhotoTest < ActiveSupport::TestCase
  should_use_table "tblPhotos"
  should_use_primary_key "PhotoID"
  
  should_have_db_column "AquaticActivityID", :type => :integer
  should_have_db_column "Path", :limit => 50, :type => :string
  should_have_db_column "FileName", :limit => 50, :type => :string

  should_have_instance_methods :aquatic_activity_id, :path, :file_name
end
