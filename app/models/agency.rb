class Agency < ActiveRecord::Base
  has_many :users
  has_many :aquatic_site_usages, :foreign_key => 'agency_code'
  
  validates_presence_of   :name
  
  generator_for :name => 'AgencyName'
  generator_for(:code, :start => 'AG0') { |prev| prev.succ }

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
