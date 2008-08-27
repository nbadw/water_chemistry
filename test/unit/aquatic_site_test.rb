require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class AquaticSiteTest < ActiveSupport::TestCase
  should_use_table "tblAquaticSite"
  should_use_primary_key "AquaticSiteId"
  
  should_belong_to :waterbody
  should_have_many :aquatic_site_usages
  should_have_many :aquatic_activities, :through => :aquatic_site_usages
  should_have_many :agencies, :through => :aquatic_site_usages
   
  should_require_attributes :description, :waterbody
  
  should_have_db_column "AquaticSiteId", :type => :integer, :null => false
  should_have_db_column "OldAquaticSiteId", :type => :integer
  should_have_db_column "RiverSystemId", :type => :integer 
  should_have_db_column "WaterbodyId", :type => :integer 
  should_have_db_column :waterbodyname, :type => :string, :limit => 50
  should_have_db_column :aquaticsitename, :type => :string, :limit => 100
  should_have_db_column :aquaticsitedesc, :type => :string, :limit => 250
  should_have_db_column :habitatdesc, :type => :string, :limit => 50
  should_have_db_column :reachno, :type => :integer 
  should_have_db_column :startdesc, :type => :string, :limit => 100
  should_have_db_column :enddesc, :type => :string, :limit => 100
  should_have_db_column :startroutemeas, :type => :float
  should_have_db_column :endroutemeas, :type => :float 
  should_have_db_column :sitetype, :type => :string, :limit => 20
  should_have_db_column :specificsiteind, :type => :string, :limit => 1
  should_have_db_column :georeferencedind, :type => :string, :limit => 1
  should_have_db_column :dateentered, :type => :datetime
  should_have_db_column :incorporatedind, :type => :boolean, :default => false
  should_have_db_column :coordinatesource, :type => :string, :limit => 50  
  should_have_db_column :coordinatesystem, :type => :string, :limit => 50
  should_have_db_column :xcoordinate, :type => :string, :limit => 50
  should_have_db_column :ycoordinate,  :type => :string, :limit => 50
  should_have_db_column :coordinateunits, :type => :string, :limit => 50
  should_have_db_column :comments, :type => :string, :limit => 50    
  
  should_have_instance_methods :aquatic_site_id, :old_aquatic_site_id, :waterbody_id, :waterbody_name, 
    :aquatic_site_name, :aquatic_site_desc, :habitat_desc, :reach_no, :start_desc, :end_desc, :start_route_meas,
    :end_route_meas, :site_type, :specific_site_ind, :geo_referenced_ind, :date_entered, :incorporated_ind, :coordinate_source,
    :coordinate_system, :x_coordinate, :y_coordinate, :coordinate_units, :comments
  
  should_alias_attribute :aquatic_site_name, :name
  should_alias_attribute :aquatic_site_desc, :description
  should_alias_attribute :x_coordinate, :raw_longitude
  should_alias_attribute :y_coordinate, :raw_latitude

  
  should "not validate location value objects when they are blank" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(true)      
      expects(:valid?).never
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)
    assert aquatic_site.valid?
  end
  
  should "be valid if all location value objects are valid" do
    aquatic_site = AquaticSite.spawn
    location = mock('dummy_location') do
      expects(:blank?).at_least(2).returns(false)
      expects(:valid?).at_least(2).returns(true)
    end
    aquatic_site.expects(:recorded_location).returns(location)
    aquatic_site.expects(:gmap_location).returns(location)    
    assert aquatic_site.valid?
  end
  
  should "copy errors from location value objects when they are not valid" do
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
      
    should "throw error if delete is attempted" do 
      assert_raise(AquaticDataWarehouse::RecordIsIncorporated) { AquaticSite.destroy @aquatic_site.id }
    end
  end
  
  context "when activity events are attached to aquatic site" do
    setup do
      @aquatic_site = AquaticSite.generate!
      AquaticSiteUsage.generate!(:aquatic_site => @aquatic_site)
      assert_equal 1, @aquatic_site.aquatic_site_usages.length
    end
    
    should "throw error if delete is attempted" do
      assert_raise(AquaticSite::AquaticSiteInUse) { @aquatic_site.destroy }
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
  end
end
