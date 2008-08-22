# == Schema Information
# Schema version: 1
#
# Table name: aquatic_site_usages
#
#  id                  :integer(11)     not null, primary key
#  aquatic_site_id     :integer(11)     
#  aquatic_activity_id :integer(11)     
#  aquatic_site_type   :string(60)      
#  agency_id           :integer(11)     
#  agency_site_id      :string(32)      
#  start_year          :string(4)       
#  end_year            :string(4)       
#  years_active        :string(40)      
#  imported_at         :datetime        
#  exported_at         :datetime        
#  created_at          :datetime        
#  updated_at          :datetime        
#

class AquaticSiteUsage < ActiveRecord::Base  
  belongs_to :aquatic_site
  belongs_to :aquatic_activity
  belongs_to :agency
  
  validates_presence_of :aquatic_site, :aquatic_activity, :agency
  validates_uniqueness_of :aquatic_activity_id, :scope => :aquatic_site_id
end
