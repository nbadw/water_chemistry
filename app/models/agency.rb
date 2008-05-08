class Agency < ActiveRecord::Base
  set_primary_key 'code'
  
  has_many :users, :foreign_key => 'agency_code'
  has_many :aquatic_site_usages, :foreign_key => 'agency_code'
  
  validates_presence_of   :name
  
  def to_label
    self.id
  end  
  
  def self.import_from_datawarehouse(attributes)
    record = Agency.new
    record.id = attributes['agencycd']
    record.name = attributes['agency']
    record.agency_type = attributes['agencytype']
    record.data_rules = attributes['datarulesind'] == 'Y' ? true : false
    record.save(false)
  end
end
