require File.dirname(__FILE__) + '/../test_helper'

class AquaticActivityEventTest < ActiveSupport::TestCase
  should_use_table :tblaquaticactivity
  should_use_primary_key :aquaticactivityid
   
  should_belong_to :aquatic_activity, :aquatic_site, :agency, :secondary_agency, :aquatic_activity_method    
  should_require_attributes :aquatic_site, :agency, :aquatic_activity, :aquatic_activity_method, :start_date
     
  should_have_db_column  :tempaquaticactivityid, :type => :integer
  should_alias_attribute :tempaquaticactivityid, :temporary_aquatic_activity_id
  
  should_have_db_column  :project, :type => :string, :limit => 100
  
  should_have_db_column  :permitno, :type => :string, :limit => 20  
  should_alias_attribute :permitno, :permit_no
  
  should_have_db_column  :aquaticprogramid, :type => :integer
  should_alias_attribute :aquaticprogramid, :aquatic_program_id
  
  should_have_db_column  :aquaticactivitycd, :type => :integer
  should_alias_attribute :aquaticactivitycd, :aquatic_activity_cd
  should_alias_attribute :aquaticactivitycd, :aquatic_activity_id
  
  should_have_db_column  :aquaticmethodcd, :type => :integer
  should_alias_attribute :aquaticmethodcd, :aquatic_activity_method_id
      
  should_have_db_column  :aquaticsiteid, :type => :integer
  should_alias_attribute :aquaticsiteid, :aquatic_site_id
  
  should_have_db_column  :oldaquaticsiteid, :type => :integer
  should_alias_attribute :oldaquaticsiteid, :old_aquatic_site_id
  
  should_have_db_column  :aquaticactivitystartdate, :type => :string, :limit => 10
  should_alias_attribute :aquaticactivitystartdate, :aquatic_activity_start_date
  
  should_have_db_column  :aquaticactivityenddate, :type => :string, :limit => 10
  should_alias_attribute :aquaticactivityenddate, :aquatic_activity_end_date
  
  should_have_db_column  :aquaticactivitystarttime, :type => :string, :limit => 6
  should_alias_attribute :aquaticactivitystarttime, :aquatic_activity_start_time
  
  should_have_db_column  :aquaticactivityendtime, :type => :string, :limit => 6  
  should_alias_attribute :aquaticactivityendtime, :aquatic_activity_end_time
  
  should_have_db_column  :year, :type => :string, :limit => 4
  
  should_have_db_column  :agencycd, :type => :string, :limit => 4
  should_alias_attribute :agencycd, :agency_cd
  should_alias_attribute :agencycd, :agency_code
  
  should_have_db_column  :agency2cd, :type => :string, :limit => 4
  should_alias_attribute :agency2cd, :agency2_cd
  should_alias_attribute :agency2cd, :secondary_agency_code
  
  should_have_db_column  :agency2contact, :type => :string, :limit => 50
  should_alias_attribute :agency2contact, :agency2_contact
  should_alias_attribute :agency2contact, :secondary_agency_contact
  
  should_have_db_column  :aquaticactivityleader, :type => :string, :limit => 50
  should_alias_attribute :aquaticactivityleader, :aquatic_activity_leader
  should_alias_attribute :aquaticactivityleader, :activity_leader
  
  should_have_db_column  :crew, :type => :string, :limit => 50
  
  should_have_db_column  :weatherconditions, :type => :string, :limit => 50
  should_alias_attribute :weatherconditions, :weather_conditions
  
  should_have_db_column  :watertemp_c, :type => :float
  should_alias_attribute :watertemp_c, :water_temperature_c
  
  should_have_db_column  :airtemp_c, :type => :float
  should_alias_attribute :airtemp_c, :air_temperature_c
    
  should_have_db_column  :waterlevel, :type => :string, :limit => 6
  should_alias_attribute :waterlevel, :water_level
  
  should_have_db_column  :waterlevel_cm, :type => :string, :limit => 50
  should_alias_attribute :waterlevel_cm, :water_level_cm
  
  should_have_db_column  :waterlevel_am_cm, :type => :string, :limit => 50
  should_alias_attribute :waterlevel_am_cm, :water_level_am_cm
  should_alias_attribute :waterlevel_am_cm, :morning_water_level_cm
  
  should_have_db_column  :waterlevel_pm_cm, :type => :string, :limit => 50
  should_alias_attribute :waterlevel_pm_cm, :water_level_pm_cm
  should_alias_attribute :waterlevel_pm_cm, :evening_water_level_cm
  
  should_have_db_column  :siltation, :type => :string, :limit => 50
  
  should_have_db_column  :primaryactivityind, :type => :boolean
  should_alias_attribute :primaryactivityind, :primary_activity_ind
  should_alias_attribute :primaryactivityind, :primary_activity_indicator
  should_alias_attribute :primaryactivityind, :primary_activity
  
  should_have_db_column  :comments, :type => :string
  
  should_have_db_column  :dateentered, :type => :datetime
  should_alias_attribute :dateentered, :date_entered
  
  should_have_db_column  :incorporatedind, :type => :boolean
  should_alias_attribute :incorporatedind, :incorporated_ind
  should_alias_attribute :incorporatedind, :incorporated_indicator
  should_alias_attribute :incorporatedind, :incorporated
  
  should_have_db_column  :datetransferred, :type => :datetime
  should_alias_attribute :datetransferred, :date_transferred
  
  should_have_db_column  :rainfall_last24, :type => :string, :limit => 15
  should_alias_attribute :rainfall_last24, :rain_fall_in_last_24_hours
  
  should_have_db_column  :start_date, :type => :datetime
  
  should_have_db_column  :end_date, :type => :datetime
  
  should_have_db_column  :agency_id, :type => :integer
  
  should_have_db_column  :agency2_id, :type => :integer
  should_alias_attribute :agency2_id, :secondary_agency_id
  
  should_define_timestamps  
  
  context "with an existing record" do
    setup do
      @tbl_aquatic_activity = AquaticActivityEvent.generate!      
    end
    
    should_allow_values_for :rainfall_last24, AquaticActivityEvent.rainfall_last24_options
    should_allow_values_for :weather_conditions, AquaticActivityEvent.weather_conditions_options
    should_allow_values_for :water_level, AquaticActivityEvent.water_level_options
  end
end
