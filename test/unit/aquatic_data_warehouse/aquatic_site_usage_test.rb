require File.dirname(__FILE__) + '/../../test_helper'

class AquaticSiteUsageTest < ActiveSupport::TestCase
  should_use_table 'tblAquaticSiteAgencyUse'
  should_use_primary_key 'AquaticSiteUseID'
  
  should_have_db_column "AgencyCd", :limit => 4, :type => :string
  should_have_db_column "AgencySiteID", :limit => 16, :type => :string
  should_have_db_column "AquaticActivityCd", :type => :integer
  should_have_db_column "AquaticSiteID", :type => :integer
  should_have_db_column "AquaticSiteType", :limit => 30, :type => :string
  should_eventually '_have_db_column "DateEntered", :type => :timestamp'
  should_have_db_column "EndYear", :limit => 4, :type => :string
  should_have_db_column "IncorporatedInd", :type => :boolean
  should_have_db_column "StartYear", :limit => 4, :type => :string
  should_have_db_column "YearsActive", :limit => 20, :type => :string
  
  should_have_instance_methods :agency_cd, :agency_site_id, :aquatic_activity_cd,
    :aquatic_site_id, :aquatic_site_type, :date_entered, :end_year, :incorporated_ind,
    :start_year, :years_active
  
  should_belong_to :aquatic_site, :aquatic_activity, :agency 
  
  should_require_attributes :aquatic_site, :agency, :aquatic_activity
  
  context "with an existing record" do
    setup { AquaticSiteUsage.generate! }
    should_require_unique_attributes :aquatic_activity_cd, :scoped_to => :aquatic_site_id
  end
end
