# == Schema Information
# Schema version: 1
#
# Table name: tblaquaticsite
#
#  aquaticsiteid    :integer(11)     not null, primary key
#  oldaquaticsiteid :integer(11)     
#  riversystemid    :integer(11)     
#  waterbodyid      :integer(11)     
#  waterbodyname    :string(50)      
#  aquaticsitename  :string(100)     
#  aquaticsitedesc  :string(250)     
#  habitatdesc      :string(50)      
#  reachno          :integer(11)     
#  startdesc        :string(100)     
#  enddesc          :string(100)     
#  startroutemeas   :float           
#  endroutemeas     :float           
#  sitetype         :string(20)      
#  specificsiteind  :string(1)       
#  georeferencedind :string(1)       
#  dateentered      :datetime        
#  incorporatedind  :boolean(1)      
#  coordinatesource :string(50)      
#  coordinatesystem :string(50)      
#  xcoordinate      :string(50)      
#  ycoordinate      :string(50)      
#  coordinateunits  :string(50)      
#  comments         :string(50)      
#  gmap_latitude    :decimal(15, 10) 
#  gmap_longitude   :decimal(15, 10) 
#  imported_at      :datetime        
#  exported_at      :datetime        
#  created_at       :datetime        
#  updated_at       :datetime        
#

class AquaticSite < ActiveRecord::Base  
  include AquaticDataWarehouse::IncorporatedModel   
  
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError; end  
  
  set_table_name  'tblaquaticsite'
  set_primary_key 'aquaticsiteid'
  
  alias_attribute :name, :aquaticsitename
  alias_attribute :description, :aquaticsitedesc
  alias_attribute :waterbody_id, :waterbodyid
  alias_attribute :waterbody_name, :waterbodyname
  alias_attribute :raw_longitude, :xcoordinate
  alias_attribute :raw_latitude, :ycoordinate
  alias_attribute :coordinate_system_id, :coordinatesystem
  alias_attribute :coordinate_source, :coordinatesource
        
  belongs_to :waterbody, :foreign_key => 'waterbodyid'
  has_many   :aquatic_site_usages
  has_many   :aquatic_activities, :through => :aquatic_site_usages, :uniq => true
  has_many   :agencies, :through => :aquatic_site_usages, :uniq => true
  
  composed_of :recorded_location, :class_name => 'Location', :mapping => [%w(raw_latitude latitude), %w(raw_longitude longitude), %w(coordinate_system_id coordinate_system_id)]
  composed_of :gmap_location, :class_name => 'GmapLocation', :mapping => [%w(gmap_latitude latitude), %w(gmap_longitude longitude)]  
        
  before_destroy :destroy_allowed?
    
  validates_presence_of :description, :waterbody  
  validates_each :recorded_location, :allow_blank => true do |record, attr, recorded_location|
    recorded_location.copy_errors_to(record, [:raw_latitude, :raw_longitude, :coordinate_system_id]) unless recorded_location.valid?
  end
  validates_each :gmap_location, :allow_blank => true do |record, attr, gmap_location|
    gmap_location.copy_errors_to(record, [:gmap_latitude, :gmap_longitude]) unless gmap_location.valid?
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
  
  
  
  class << self
    def name_column
      :name
    end
    
    def waterbody_id_column
      :waterbody_id
    end
  end
end
