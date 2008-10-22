# == Schema Information
# Schema version: 20081008163622
#
# Table name: cdAgency
#
#  AgencyCd     :string(5)       not null, primary key
#  Agency       :string(60)      
#  AgencyType   :string(4)       
#  DataRulesInd :string(1)       
#  created_at   :datetime        
#  updated_at   :datetime        
#  created_by   :integer(11)     
#  updated_by   :integer(11)     
#

class Agency < AquaticDataWarehouse::BaseCd  
  set_primary_key 'AgencyCd'
  
  has_many :users
  has_many :aquatic_site_usages, :foreign_key => 'AgencyCd', :uniq => true
  
  alias_attribute :code, :agency_cd
  alias_attribute :name, :agency
  
  validates_presence_of :name  
end
