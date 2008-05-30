class CdAgency < ActiveRecord::Base  
  set_table_name  'cdAgency'
  set_primary_key 'agencycd'
  
  alias_attribute :code, :id
  alias_attribute :name, :agency
  
  has_many :users, :foreign_key => 'agency_code'
  #  has_many :aquatic_site_usages, :foreign_key => 'agency_code'
  
  acts_as_importable
  
  validates_presence_of   :name

  def to_label
    self.code
  end  
  
#  def self.import_from_datawarehouse(attributes)
#    record = Agency.new
#    record.id = attributes['agencycd']
#    record.name = attributes['agency']
#    record.agency_type = attributes['agencytype']
#    record.data_rules = attributes['datarulesind'] == 'Y' ? true : false
#    record.save(false)
#  end
end
