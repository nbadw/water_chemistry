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
  
  def self.import_from_datawarehouse(attributes)
    site = AquaticSite.new
    site.id = attributes['aquaticsiteid']
    site.old_aquatic_site_id = attributes['oldaquaticsiteid']
    site.river_system_id = attributes['riversystemid']
    site.waterbody_id = attributes['waterbodyid']
    site.name = attributes['aquaticsitename']
    site.description = attributes['aquaticsitedesc']
    site.habitat_desc = attributes['habitatdesc']
    site.reach_no = attributes['reachno']
    site.start_desc = attributes['startdesc']
    site.end_desc = attributes['enddesc']
    site.start_route_meas = attributes['startroutemeas']
    site.end_route_meas = attributes['endroutemeas']
    site.site_type = attributes['sitetype']
    site.specific_site = attributes['specificsiteind'] == 'Y' ? true : false
    site.georeferenced = attributes['georeferenced'] == 'Y' ? true : false
    site.entered_at = attributes['date_entered']
    site.incorporated_at = attributes['incorporatedind'] ? DateTime.now : nil
    site.coordinate_source = attributes['coordinatesource']
    site.coordinate_system = attributes['coordinatesystem']
    site.coordinate_units = attributes['coordinateunits']
    site.x_coord = attributes['xcoordinate']
    site.y_coord = attributes['ycoordinate']
    site.comments = attributes['comments']
    site.save(false)
  end
  
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
