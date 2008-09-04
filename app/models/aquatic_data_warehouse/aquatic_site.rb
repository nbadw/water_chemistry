# == Schema Information
# Schema version: 2
#
# Table name: tblaquaticsite
#
#  aquaticsiteid             :integer(11)     not null, primary key
#  oldaquaticsiteid          :integer(11)     
#  riversystemid             :integer(11)     
#  waterbodyid               :integer(11)     
#  waterbodyname             :string(50)      
#  aquaticsitename           :string(100)     
#  aquaticsitedesc           :string(250)     
#  habitatdesc               :string(50)      
#  reachno                   :integer(11)     
#  startdesc                 :string(100)     
#  enddesc                   :string(100)     
#  startroutemeas            :float           
#  endroutemeas              :float           
#  sitetype                  :string(20)      
#  specificsiteind           :string(1)       
#  georeferencedind          :string(1)       
#  dateentered               :datetime        
#  incorporatedind           :boolean(1)      
#  coordinatesource          :string(50)      
#  coordinatesystem          :string(50)      
#  xcoordinate               :string(50)      
#  ycoordinate               :string(50)      
#  coordinateunits           :string(50)      
#  comments                  :string(50)      
#  gmap_latitude             :decimal(15, 10) 
#  gmap_longitude            :decimal(15, 10) 
#  imported_at               :datetime        
#  exported_at               :datetime        
#  created_at                :datetime        
#  updated_at                :datetime        
#  gmap_coordinate_system_id :integer(11)     
#  coordinate_system_id      :integer(11)     
#  coordinate_source_id      :integer(11)     
#

class AquaticSite < AquaticDataWarehouse::BaseTbl
  set_primary_key 'AquaticSiteID'
  
  belongs_to :waterbody, :foreign_key => 'WaterBodyID'
  has_many :aquatic_site_usages, :foreign_key => 'AquaticSiteID', :uniq => true
  has_many :aquatic_activities, :through => :aquatic_site_usages
  has_many :agencies, :through => :aquatic_site_usages
  
  alias_attribute :name, :aquatic_site_name
  alias_attribute :description, :aquatic_site_desc
  alias_attribute :incorporated, :incorporated_ind
    
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
end
