class AquaticSite < ActiveRecord::Base
  class << self
    def name_column
      :name
    end
    
    def waterbody_id_column
      :waterbody_id
    end
  end
  
  include AquaticDataWarehouse::IncorporatedModel
  
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError; end  
        
  belongs_to :waterbody
  belongs_to :coordinate_source
  has_many   :aquatic_site_usages
  has_many   :aquatic_activities, :through => :aquatic_site_usages, :uniq => true
  has_many   :agencies, :through => :aquatic_site_usages, :uniq => true
  
  composed_of :recorded_location, :class_name => 'Location', :mapping => [%w(raw_latitude latitude), %w(raw_longitude longitude), %w(coordinate_system_id coordinate_system_id)]
  composed_of :gmap_location, :class_name => 'Location', :mapping => [%w(gmap_latitude latitude), %w(gmap_longitude longitude), %w(gmap_coordinate_system_id coordinate_system_id)]
        
  before_destroy :destroy_allowed?
    
  validates_presence_of :description, :waterbody  
  validates_each :recorded_location, :allow_blank => true do |record, attr, recorded_location|
    unless recorded_location.valid?
      [recorded_location.errors.on(:latitude)].flatten.each { |error| record.errors.add :raw_latitude, error }
      [recorded_location.errors.on(:longitude)].flatten.each { |error| record.errors.add :raw_longitude, error }
      [recorded_location.errors.on(:coordinate_system_id)].flatten.each { |error| record.errors.add :coordinate_system_id, error }
    end
  end
  validates_each :gmap_location, :allow_blank => true do |record, attr, gmap_location|
    unless gmap_location.valid?
      [gmap_location.errors.on(:latitude)].flatten.each { |error| record.errors.add :gmap_latitude, error }
      [gmap_location.errors.on(:longitude)].flatten.each { |error| record.errors.add :gmap_longitude, error }
      [gmap_location.errors.on(:coordinate_system_id)].flatten.each { |error| record.errors.add :gmap_coordinate_system_id, error }
    end
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
