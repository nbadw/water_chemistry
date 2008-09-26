# == Schema Information
# Schema version: 20080923163956
#
# Table name: tblAquaticSiteAgencyUse
#
#  AquaticSiteUseID  :integer(10)     not null, primary key
#  AquaticSiteID     :integer(10)     
#  AquaticActivityCd :integer(5)      
#  AquaticSiteType   :string(30)      
#  AgencyCd          :string(4)       
#  AgencySiteID      :string(16)      
#  StartYear         :string(4)       
#  EndYear           :string(4)       
#  YearsActive       :string(20)      
#  DateEntered       :datetime        
#  IncorporatedInd   :boolean(1)      not null
#  created_at        :datetime        
#  updated_at        :datetime        
#  created_by        :integer(11)     
#  updated_by        :integer(11)     
#

class AquaticSiteUsage < AquaticDataWarehouse::BaseTbl 
  set_table_name  'tblAquaticSiteAgencyUse'
  set_primary_key 'AquaticSiteUseID'
  
  belongs_to :aquatic_site, :foreign_key => 'AquaticSiteID'
  belongs_to :aquatic_activity, :foreign_key => 'AquaticActivityCd'
  belongs_to :agency, :foreign_key => 'AgencyCd'
  
  validates_presence_of :aquatic_site, :aquatic_activity, :agency
  validates_uniqueness_of :aquatic_activity_cd, :scope => :aquatic_site_id
  
  def before_save
    write_attribute('IncorporatedInd', false) if incorporated_ind.nil?
    return self
  end
end
