class AquaticSite < ActiveRecord::Base
  class RecordIsIncorporated < ActiveRecord::ActiveRecordError
  end
  class SiteUsagesAttached < ActiveRecord::ActiveRecordError    
  end
  
  before_destroy :check_if_incorporated
  before_destroy :check_if_aquatic_site_usages_attached
  acts_as_paranoid  
  
  belongs_to :waterbody
  has_many   :aquatic_site_usages
  has_many   :activities, :through => :aquatic_site_usages
  
  validates_presence_of :name, :description, :waterbody
  
  alias_attribute :lat, :wgs84_lat
  alias_attribute :lon, :wgs84_lon
      
  def incorporated?
    !self.incorporated_at.nil?
  end
  
  def agencies
    aquatic_site_usages.collect{ |usage| usage.agency_code }.uniq
  end
  
  def waterbody_id
    waterbody ? waterbody.id : 'No Waterbody ID!' 
  end
  
  def drainage_code
    waterbody.drainage_code if waterbody
  end
  
  acts_as_importable 'tblAquaticSite', :perform_validations => false
  import_transformation_for 'AquaticSiteName', 'name'
  import_transformation_for 'AquaticSiteDesc', 'description'
  import_transformation_for('SpecificSiteInd', 'specific_site') { |attr, val, column| val == 'Y' }
  import_transformation_for('Georeferenced')   { |attr, val, column| val == 'Y' }
  import_transformation_for('IncorporatedInd', 'incorporated_at') { |attr, val, column| val ? DateTime.now : nil }
  
  private
  def check_if_incorporated
    raise(RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
  end
  
  def check_if_aquatic_site_usages_attached
    raise(
      SiteUsagesAttached, 
      "Site usages are attached, record cannot be deleted"
    ) if self.aquatic_site_usages.size > 0
  end
end
