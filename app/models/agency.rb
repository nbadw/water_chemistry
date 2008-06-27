class Agency < ActiveRecord::Base      
  has_many :users
  has_many :aquatic_site_agency_usages, :class_name => 'TblAquaticSiteAgencyUse', :foreign_key => 'agencycd'    
  validates_presence_of :name
end
