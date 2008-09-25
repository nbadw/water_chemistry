# == Schema Information
# Schema version: 1
#
# Table name: tblAquaticSite
#
#  AquaticSiteID    :integer(10)     not null, primary key
#  oldAquaticSiteID :integer(10)     
#  RiverSystemID    :integer(5)      
#  WaterBodyID      :integer(10)     
#  WaterBodyName    :string(50)      
#  AquaticSiteName  :string(100)     
#  AquaticSiteDesc  :string(250)     
#  HabitatDesc      :string(50)      
#  ReachNo          :integer(10)     
#  StartDesc        :string(100)     
#  EndDesc          :string(100)     
#  StartRouteMeas   :float(15)       
#  EndRouteMeas     :float(15)       
#  SiteType         :string(20)      
#  SpecificSiteInd  :string(1)       
#  GeoReferencedInd :string(1)       
#  DateEntered      :datetime        
#  IncorporatedInd  :boolean(1)      not null
#  CoordinateSource :string(50)      
#  CoordinateSystem :string(50)      
#  XCoordinate      :string(50)      
#  YCoordinate      :string(50)      
#  CoordinateUnits  :string(50)      
#  Comments         :string(150)     
#

class AquaticSite < AquaticDataWarehouse::BaseTbl
  set_primary_key 'AquaticSiteID'
  
  belongs_to :waterbody, :foreign_key => 'WaterBodyID'
  has_many :aquatic_site_usages, :foreign_key => 'AquaticSiteID', :uniq => true
  has_many :aquatic_activities, :through => :aquatic_site_usages
  has_many :agencies, :through => :aquatic_site_usages
  
  alias_attribute :name, :aquatic_site_name
  alias_attribute :description, :aquatic_site_desc
    
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError; end  
                
  composed_of :location, :class_name => 'Location', :mapping => [%w(y_coordinate latitude), %w(x_coordinate longitude), %w(coordinate_system coordinate_system)]
  validates_location :location, :allow_blank => true
#  composed_of :gmap_location, :class_name => 'GmapLocation', :mapping => [%w(gmap_latitude latitude), %w(gmap_longitude longitude)]  
#        
#  before_destroy :destroy_allowed?
#    
  validates_presence_of :aquatic_site_desc, :waterbody  
#  validates_each :recorded_location, :allow_blank => true do |record, attr, recorded_location|
#    recorded_location.copy_errors_to(record, [:raw_latitude, :raw_longitude, :coordinate_system_id]) unless recorded_location.valid?
#  end
#  validates_each :gmap_location, :allow_blank => true do |record, attr, gmap_location|
#    gmap_location.copy_errors_to(record, [:gmap_latitude, :gmap_longitude]) unless gmap_location.valid?
#  end
#  
#  private   
#  def destroy_allowed?
#    check_if_incorporated
#    check_if_in_use
#  end
#  
#  def check_if_in_use
#    raise(AquaticSiteInUse, "Site is in use, record cannot be deleted") unless self.aquatic_site_usages.empty?
#  end
#  def before_save
#    write_attribute('IncorporatedInd', false) if incorporated_ind.nil?
#    return self
#  end
  
  def attached_data_sets
    aquatic_activities.uniq
  end
  
  def unattached_data_sets
    AquaticActivity.find(:all) - attached_data_sets
  end
end
