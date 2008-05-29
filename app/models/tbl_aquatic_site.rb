class TblAquaticSite < ActiveRecord::Base
  set_table_name  'tblAquaticSite'
  set_primary_key 'aquaticsiteid'
  
  belongs_to :waterbody, :class_name => 'TblWaterbody', :foreign_key => 'waterbodyid'  
  
  acts_as_importable
  #  class RecordIsIncorporated < ActiveRecord::ActiveRecordError
  #  end
  #  class SiteUsagesAttached < ActiveRecord::ActiveRecordError    
  #  end
  #  
  #  before_destroy :check_if_incorporated
  #  before_destroy :check_if_aquatic_site_usages_attached
  #  acts_as_paranoid  
  #  
  #  has_many   :aquatic_site_usages
  #  has_many   :activities, :through => :aquatic_site_usages
  #  
  #  has_many   :aquatic_activities
  #  
  #  validates_presence_of :name, :description, :waterbody
  #  
  #  alias_attribute :lat, :wgs84_lat
  #  alias_attribute :lon, :wgs84_lon
  #      
  #  def incorporated?
  #    !self.incorporated_at.nil?
  #  end
  #  
  #  def agencies
  #    aquatic_site_usages.collect{ |usage| usage.agency_code }.uniq
  #  end
  #  
  #  def waterbody_id
  #    waterbody ? waterbody.id : 'No Waterbody ID!' 
  #  end
  #  
  #  def drainage_code
  #    waterbody.drainage_code if waterbody
  #  end
  #  
  #  acts_as_importable 'tblAquaticSite'
  ##  def self.import_from_data_warehouse
  ##    records = FasterCSV.read("#{RAILS_ROOT}/db/import/tblAquaticSite.csv")
  ##    columns = [
  ##      :id,                  #0
  ##      :old_aquatic_site_id, #1
  ##      :river_system_id,     #2
  ##      :waterbody_id,        #3
  ##      :name,                #4
  ##      :description,         #5
  ##      :habitat_desc,        #6
  ##      :reach_no,            #7
  ##      :start_desc,          #8
  ##      :end_desc,            #9
  ##      :start_route_meas,    #10
  ##      :end_route_meas,      #11
  ##      :site_type,           #12
  ##      :specific_site,       #13
  ##      :georeferenced,       #14
  ##      :entered_at,          #15
  ##      :incorporated_at,     #16
  ##      :coordinate_source,   #17
  ##      :coordinate_system,   #18
  ##      :coordinate_units,    #19
  ##      :x_coord,             #20
  ##      :y_coord,             #21
  ##      :comments             #22
  ##    ]
  ##    
  ##    records.collect! do |record| 
  ##      record.delete_at(4) # delete WaterBodyName
  ##      record[13] = record[13] == 'Y' # SpecificSiteInd
  ##      record[14] = record[14] == 'Y' # GeoreferencedInd      
  ##      record[16] = DateTime.now if record[16] # IncorporatedInd
  ##      record      
  ##    end
  ##    
  ##    self.import columns, records, { :validate => false }
  ##  end
  #  import_transformation_for 'AquaticSiteName', 'name'
  #  import_transformation_for 'AquaticSiteDesc', 'description'
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
