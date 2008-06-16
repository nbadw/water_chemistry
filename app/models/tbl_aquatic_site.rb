class TblAquaticSite < ActiveRecord::Base
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError;end      
  class RecordIsIncorporated < ActiveRecord::ActiveRecordError;end
  
  set_table_name  'tblAquaticSite'
  set_primary_key 'aquaticsiteid'
  
  alias_attribute :name, :aquaticsitename
  alias_attribute :description, :aquaticsitedesc
  alias_attribute :waterbody_id, :waterbodyid
  alias_attribute :waterbody_name, :waterbodyname    
  alias_attribute :latitude, :wgs84_lat
  alias_attribute :longitude, :wgs84_lon
  alias_attribute :incorporated, :incorporatedind
  
  belongs_to :waterbody, :class_name => 'TblWaterbody', :foreign_key => 'waterbodyid'  
  has_many   :aquatic_site_agency_usages, :class_name => 'TblAquaticSiteAgencyUse', :foreign_key => 'aquaticsiteid'
  has_many   :aquatic_activity_codes, :through => :aquatic_site_agency_usages, :uniq => true
  has_many   :agencies, :through => :aquatic_site_agency_usages, :uniq => true
      
  before_destroy :check_if_incorporated
  before_destroy :check_if_aquatic_site_agency_usages_attached
    
  validates_presence_of :description, :waterbody    
  
  def authorized_for_destroy?
    !incorporated?
  end
  
  def authorized_for_update?
    !incorporated?
  end
  
  def drainage_code
    self.waterbody.drainage_code if self.waterbody
  end
  
  def incorporated?
    !!read_attribute(:incorporatedind)        
  end    
  
  private
  def check_if_incorporated
    raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
  end
    
  def check_if_aquatic_site_agency_usages_attached
    raise(
      AquaticSiteInUse, 
      "Site usages are attached, record cannot be deleted"
    ) if self.aquatic_site_agency_usages.count > 0
  end
end
