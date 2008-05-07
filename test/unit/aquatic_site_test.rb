require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteTest < ActiveSupport::TestCase
  should_have_many :activity_events
  should_have_many :activities, :through => :activity_events  
  should_require_attributes :geom
      
  context "acting as paranoid" do
    setup do
      @deleted = AquaticSite.generate!
      assert_nil @deleted.deleted_at
      AquaticSite.delete @deleted.id
    end
        
    should_have_db_column :deleted_at, :type => 'timestamp'
    
    should "not find sites that have been deleted" do
      assert_nil AquaticSite.find(:first)
    end
    
    should "not count sites that have been deleted" do
      assert_equal 0, AquaticSite.count
    end
    
    should "be able to retrieve record using find_with_deleted" do
      assert_equal @deleted, AquaticSite.find_with_deleted(:first)
    end
    
    should "be countable using count_with_deleted" do 
      assert_equal 1, AquaticSite.count_with_deleted
    end
    
    should "be able to delete completely using destroy!" do
      @deleted.destroy!
      assert_equal 0, AquaticSite.count_with_deleted
    end
  end
  
  context "when activity events are attached to aquatic site" do
    setup do
      @aquatic_site = AquaticSite.generate!
      @aquatic_site.activity_events << ActivityEvent.generate!
    end
    
    should_eventually "cascade delete to activity events" do
      
    end
    
    context "when site has been commited to data warehouse" do
      setup { @aquatic_site.export_to_datawarehouse }
      
      should_eventually "throw error if delete is attempted" do
        
      end
    end
  end
end
