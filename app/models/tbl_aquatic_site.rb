class TblAquaticSite < ActiveRecord::Base
  set_table_name  'tblAquaticSite'
  set_primary_key 'aquaticsiteid'
  
  alias_attribute :name, :aquaticsitename
  alias_attribute :description, :aquaticsitedesc
  alias_attribute :waterbody_id, :waterbodyid
  alias_attribute :waterbody_name, :waterbodyname    
  alias_attribute :latitude, :wgs84_lat
  alias_attribute :longitude, :wgs84_lon
  
  belongs_to :waterbody, :class_name => 'TblWaterbody', :foreign_key => 'waterbodyid'  
  has_many   :aquatic_site_agency_usages, :class_name => 'TblAquaticSiteAgencyUse', :foreign_key => 'aquaticsiteid'
  has_many   :aquatic_activity_codes, :through => :aquatic_site_agency_usages
  
  acts_as_importable
 
  def agencies
    aquatic_site_agency_usages.collect{ |usage| usage.agency_code }.uniq
  end
  
  def drainage_code
    self.waterbody.drainage_code if self.waterbody
  end
  
  #  class RecordIsIncorporated < ActiveRecord::ActiveRecordError
  #  end
  #  class SiteUsagesAttached < ActiveRecord::ActiveRecordError    
  #  end
  #  
  #  before_destroy :check_if_incorporated
  #  before_destroy :check_if_aquatic_site_usages_attached
  #  acts_as_paranoid  
  #    
  #  has_many   :aquatic_activities
  #  
  #  validates_presence_of :name, :description, :waterbody
  #      
  #  def incorporated?
  #    !self.incorporated_at.nil?
  #  end
  #  
  #  import_transformation_for('SpecificSiteInd', 'specific_site') { |record| record['SpecificSiteInd'.downcase] == 'Y' }
  #  import_transformation_for('Georeferenced')   { |record| record['Georeferenced'.downcase] == 'Y' }
  #  import_transformation_for('IncorporatedInd', 'incorporated_at') { |record| DateTime.now if record['IncorporatedInd'.downcase] }
  #  
  #  private
  #  def check_if_incorporated
  #    raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
  #  end
  #  
  #  def check_if_aquatic_site_usages_attached
  #    raise(
  #      SiteUsagesAttached, 
  #      "Site usages are attached, record cannot be deleted"
  #    ) if self.aquatic_site_usages.size > 0
  #  end
end
