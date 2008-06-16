class CdAgency < ActiveRecord::Base  
  set_table_name  'cdAgency'
  set_primary_key 'agencycd'
  
  alias_attribute :code, :id
  alias_attribute :name, :agency
  
  has_many :users, :foreign_key => 'agency_code'
  has_many :aquatic_site_agency_usages, :class_name => 'TblAquaticSiteAgencyUse', :foreign_key => 'agencycd'
    
  validates_presence_of   :name

  def to_label
    self.code
  end  
end
