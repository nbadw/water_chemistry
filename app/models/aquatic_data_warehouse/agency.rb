# == Schema Information
# Schema version: 1
#
# Table name: cdagency
#
#  id           :integer(11)     not null
#  agencycd     :string(5)       default(""), not null, primary key
#  agency       :string(60)      
#  agencytype   :string(4)       
#  datarulesind :string(1)       default("N")
#  created_at   :datetime        
#  updated_at   :datetime        
#  imported_at  :datetime        
#  exported_at  :datetime        
#

class Agency < AquaticDataWarehouse::BaseCd  
  set_primary_key 'AgencyCd'
  
  has_many :users
  has_many :aquatic_site_usages
  
  alias_attribute :code, :agency_cd
  alias_attribute :name, :agency
  
  validates_presence_of :name
end
