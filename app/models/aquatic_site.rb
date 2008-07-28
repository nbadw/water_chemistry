class AquaticSite < ActiveRecord::Base
  include AquaticDataWarehouse::IncorporatedModel
  
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError; end  
        
  belongs_to :waterbody 
  has_many   :aquatic_site_usages
  has_many   :aquatic_activities, :through => :aquatic_site_usages, :uniq => true
  has_many   :agencies, :through => :aquatic_site_usages, :uniq => true
  
  composed_of :actual_location, :class_name => 'Location', :mapping => [%w(latitude latitude), %w(longitude longitude), %w(coordinate_system_id coordinate_system_id)]
  composed_of :recorded_location, :class_name => 'Location', :mapping => [%w(raw_latitude latitude), %w(raw_longitude longitude), %w(coordinate_system_id coordinate_system_id)]
  composed_of :gmap_location, :class_name => 'Location', :mapping => [%w(gmap_latitude latitude), %w(gmap_longitude longitude), %w(gmap_coordinate_system_id coordinate_system_id)]
        
  before_destroy :destroy_allowed?
    
  validates_presence_of :description, :waterbody  
  validates_each :actual_location, :recorded_location, :gmap_location, :allow_blank => true do |record, attr, value|
    record.errors.add attr, "#{attr} is invalid" unless value.valid?
  end
    
  def drainage_code
    self.waterbody.drainage_code if self.waterbody
  end  
  
  private   
  def destroy_allowed?
    check_if_incorporated
    check_if_in_use
  end
  
  def check_if_in_use
    raise(AquaticSiteInUse, "Site is in use, record cannot be deleted") unless self.aquatic_site_usages.empty?
  end
end
