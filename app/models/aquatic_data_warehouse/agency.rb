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
  before_save :format_agency_cd
  
  has_many :users
  has_many :aquatic_site_usages, :foreign_key => 'AgencyCd', :uniq => true
  
  alias_attribute :code, :agency_cd
  alias_attribute :name, :agency
  
  validates_presence_of   :agency, :agency_cd
  validates_uniqueness_of :agency_cd
  validates_length_of     :agency_cd, :within => 3..5

  def self.types
    all(:select => 'DISTINCT AgencyType', :order => 'AgencyType ASC').collect { |result| result['AgencyType'] }
  end

  private
  def format_agency_cd
    self.id = self.id.upcase
  end
end
