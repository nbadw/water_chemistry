require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class AquaticSiteTest < ActiveSupport::TestCase
  should_use_table "tblAquaticSite"
  should_use_primary_key "AquaticSiteID"
    
  should_belong_to :waterbody
  should_have_many :aquatic_site_usages
  should_have_many :aquatic_activities, :through => :aquatic_site_usages
  should_have_many :agencies, :through => :aquatic_site_usages
   
  should_require_attributes :aquatic_site_desc, :waterbody
  
  should_have_db_column "oldAquaticSiteID", :type => :integer
  should_have_db_column "RiverSystemID", :type => :integer 
  should_have_db_column "WaterBodyID", :type => :integer 
  should_have_db_column "WaterBodyName", :type => :string, :limit => 50
  should_have_db_column "AquaticSiteName", :type => :string, :limit => 100
  should_have_db_column "AquaticSiteDesc", :type => :string, :limit => 250
  should_have_db_column "HabitatDesc", :type => :string, :limit => 50
  should_have_db_column "ReachNo", :type => :integer 
  should_have_db_column "StartDesc", :type => :string, :limit => 100
  should_have_db_column "EndDesc", :type => :string, :limit => 100
  should_eventually '_have_db_column "StartRouteMeas", :type => :float'
  should_eventually '_have_db_column "EndRouteMeas", :type => :float'
  should_have_db_column "SiteType", :type => :string, :limit => 20
  should_have_db_column "SpecificSiteInd", :type => :string, :limit => 1
  should_have_db_column "GeoReferencedInd", :type => :string, :limit => 1
  should_have_db_column "DateEntered", :type => :datetime
  should_have_db_column "IncorporatedInd", :type => :boolean
  should_have_db_column "CoordinateSource", :type => :string, :limit => 50  
  should_have_db_column "CoordinateSystem", :type => :string, :limit => 50
  should_have_db_column "XCoordinate", :type => :string, :limit => 50
  should_have_db_column "YCoordinate",  :type => :string, :limit => 50
  should_have_db_column "CoordinateUnits", :type => :string, :limit => 50
  should_have_db_column "Comments", :type => :string, :limit => 150    
  
  should_have_instance_methods :aquatic_site_id, :old_aquatic_site_id, :water_body_id, :water_body_name, 
    :aquatic_site_name, :aquatic_site_desc, :habitat_desc, :reach_no, :start_desc, :end_desc, :start_route_meas,
    :end_route_meas, :site_type, :specific_site_ind, :geo_referenced_ind, :date_entered, :incorporated_ind, :coordinate_source,
    :coordinate_system, :x_coordinate, :y_coordinate, :coordinate_units, :comments
  
  should_alias_attribute :aquatic_site_name, :name
  should_alias_attribute :aquatic_site_desc, :description

  should "create/read/update/delete" do
    aquatic_site = AquaticSite.spawn
    assert aquatic_site.save
    db_record = AquaticSite.find(aquatic_site.id)
    assert_equal aquatic_site.id, db_record.id
    aquatic_site.name = aquatic_site.name.to_s.reverse
    assert aquatic_site.save
    assert aquatic_site.destroy
    assert !AquaticSite.exists?(aquatic_site.id)
  end
  
  should_eventually "not validate location value objects when they are blank" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(true)      
      expects(:valid?).never
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)
    assert aquatic_site.valid?
  end
  
  should_eventually "be valid if all location value objects are valid" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(false)
      expects(:valid?).at_least(2).returns(true)
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)    
    assert aquatic_site.valid?
  end
  
  should_eventually "copy errors from location value objects when they are not valid" do
    aquatic_site = AquaticSite.spawn
    recorded_location = mock('recorded_location') do
      expects(:valid?).returns(false)
      expects(:copy_errors_to).with(aquatic_site, [:raw_latitude, :raw_longitude, :coordinate_system_id])
    end
    gmap_location = mock('gmap_location') do
      expects(:valid?).returns(false)
      expects(:copy_errors_to).with(aquatic_site, [:gmap_latitude, :gmap_longitude])
    end
    aquatic_site.expects(:recorded_location).returns(recorded_location)
    aquatic_site.expects(:gmap_location).returns(gmap_location)    
    aquatic_site.valid?
  end
  
  context "when site has been incorporated into the data warehouse" do
    setup { @aquatic_site = AquaticSite.generate!(:exported_at => DateTime.now) }
      
    should_eventually "throw error if delete is attempted" do 
      assert_raise(AquaticDataWarehouse::RecordIsIncorporated) { AquaticSite.destroy @aquatic_site.id }
    end
  end
  
  context "when activity events are attached to aquatic site" do
    setup do
#      @aquatic_site = AquaticSite.generate!
#      AquaticSiteUsage.generate!(:aquatic_site => @aquatic_site)
#      assert_equal 1, @aquatic_site.aquatic_site_usages.length
    end
    
    should_eventually "throw error if delete is attempted" do
      assert_raise(AquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
