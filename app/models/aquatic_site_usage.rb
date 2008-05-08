class AquaticSiteUsage < ActiveRecord::Base
  belongs_to :aquatic_site
  belongs_to :activity, :foreign_key => 'aquatic_activity_code'
  belongs_to :agency, :foreign_key => 'agency_code'
  
  validates_presence_of :activity
    
  def waterbody
    self.aquatic_site.waterbody if self.aquatic_site
  end
  
  def waterbody_name
    waterbody ? waterbody.name : 'Unnamed Waterbody'
  end
  
  def waterbody_id
    waterbody ? waterbody.id : 'ID Not Found'
  end 
  
  def description
    (self.aquatic_site && self.aquatic_site.description) ?
      self.aquatic_site.description :
      'No Description'
  end
  
  def self.import_from_datawarehouse(attributes)
    record = AquaticSiteUsage.new
    record.id = attributes['aquaticsiteuseid']
    record.aquatic_site_id = attributes['aquaticsiteid']
    record.aquatic_activity_code = attributes['aquaticactivitycd']
    record.aquatic_site_type = attributes['aquaticsitetype']
    record.agency_code = attributes['agencycd']
    record.agency_site_id = attributes['agencysiteid']
    record.start_year = attributes['startyear']
    record.end_year = attributes['endyear']
    record.years_active = attributes['yearsactive']
    record.incorporated_at = attributes['incorporatedind'] ? DateTime.now : nil
    record.save(false)
  end
end
