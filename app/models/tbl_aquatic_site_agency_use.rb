class TblAquaticSiteAgencyUse < ActiveRecord::Base
  set_table_name  'tblAquaticSiteAgencyUse'
  set_primary_key 'aquaticsiteuseid'
  acts_as_importable
#  acts_as_importable 'tblAquaticSiteAgencyUse', :primary_key => 'AquaticSiteUseID', :exclude => ['SSMA_Timestamp']
#  import_transformation_for 'EndYear', 'end_year'
#  
#  belongs_to :aquatic_site
#  belongs_to :activity, :foreign_key => 'aquatic_activity_code'
#  belongs_to :agency, :foreign_key => 'agency_code'
#  
#  validates_presence_of :activity
#      
#  def self.import_from_datawarehouse(attributes)
#    record = AquaticSiteUsage.new
#    record.id = attributes['aquaticsiteuseid']
#    record.aquatic_site_id = attributes['aquaticsiteid']
#    record.aquatic_activity_code = attributes['aquaticactivitycd']
#    record.aquatic_site_type = attributes['aquaticsitetype']
#    record.agency_code = attributes['agencycd']
#    record.agency_site_id = attributes['agencysiteid']
#    record.start_year = attributes['startyear']
#    record.end_year = attributes['endyear']
#    record.years_active = attributes['yearsactive']
#    record.incorporated_at = attributes['incorporatedind'] ? DateTime.now : nil
#    record.save(false)
#  end
end
