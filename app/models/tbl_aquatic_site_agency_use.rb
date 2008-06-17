class TblAquaticSiteAgencyUse < ActiveRecord::Base
  set_table_name  'tblAquaticSiteAgencyUse'
  set_primary_key 'aquaticsiteuseid'

  alias_attribute :agency_code, :agencycd
  
  belongs_to :aquatic_site, :class_name => 'TblAquaticSite', :foreign_key => 'aquaticsiteid'
  belongs_to :aquatic_activity_code, :class_name => 'CdAquaticActivity', :foreign_key => 'aquaticactivitycd'
  belongs_to :agency, :class_name => 'CdAgency', :foreign_key => 'agencycd'
  
  validates_presence_of :aquatic_site, :aquatic_activity_code, :agency
end
