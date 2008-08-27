# == Schema Information
# Schema version: 1
#
# Table name: site_observations
#
#  id                        :integer(11)     not null, primary key
#  aquatic_site_id           :integer(11)     
#  aquatic_activity_event_id :integer(11)     
#  observation_id            :integer(11)     
#  value_observed            :string(255)     
#  imported_at               :datetime        
#  exported_at               :datetime        
#  created_at                :datetime        
#  updated_at                :datetime        
#  fish_passage_blocked      :boolean(1)      
#

class SiteObservation < AquaticDataWarehouse::Base
  belongs_to :aquatic_site
  belongs_to :aquatic_activity_event
  belongs_to :observation
  
  validates_presence_of :aquatic_site, :aquatic_activity_event, :observation
end
