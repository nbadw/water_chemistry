# == Schema Information
# Schema version: 20081127150314
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
#  created_at       :datetime        
#  updated_at       :datetime        
#  created_by       :integer(11)     
#  updated_by       :integer(11)     
#

class AquaticSite < AquaticDataWarehouse::BaseTbl    
  class AquaticSiteInUse < ActiveRecord::ActiveRecordError; end  
  
  set_primary_key 'AquaticSiteID'
  
  has_one     :gmap_location, :as => :locatable
  belongs_to  :waterbody, :foreign_key => 'WaterBodyID'  
  has_many    :aquatic_site_usages, :foreign_key => 'AquaticSiteID', :uniq => true
  has_many    :aquatic_activities, :through => :aquatic_site_usages
  has_many    :aquatic_activity_events, :foreign_key => 'AquaticSiteID'
  has_many    :agencies, :through => :aquatic_site_usages
  composed_of :location, :class_name => 'Location', :mapping => [%w(y_coordinate latitude), %w(x_coordinate longitude), %w(coordinate_system coordinate_system)]
  
  alias_attribute :name, :aquatic_site_name
  alias_attribute :description, :aquatic_site_desc
                     
  before_destroy :in_use?
    
  validates_presence_of :aquatic_site_desc, :waterbody 
  validates_location    :location, :allow_blank => true 
  
  def in_use?
    raise(AquaticSiteInUse, :aquatic_site_in_use_error.l('Site is in use, record cannot be deleted')) unless aquatic_site_usages.empty?
  end
  
  def attached_data_sets
    aquatic_activities.uniq
  end
  
  def unattached_data_sets
    AquaticActivity.find(:all) - attached_data_sets
  end
  
  def authorized_for_destroy?
    if existing_record_check?
      super && aquatic_site_usages.empty?
    else
      super
    end
  end
  
  def current_agency_authorized_for_update?
    current_agency_authorized_for_update_or_destroy?
  end
  
  def current_agency_authorized_for_destroy?
    current_agency_authorized_for_update_or_destroy?
  end
  
  def current_agency_authorized_for_update_or_destroy?
    if existing_record_check?
      created_by_agency = User.find(created_by, :include => :agency).agency rescue nil
      !!current_agency && (agencies.to_a.include?(current_agency) || created_by_agency == current_agency)
    else
      !!current_agency 
    end
  end
end
