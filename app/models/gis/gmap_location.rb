# == Schema Information
# Schema version: 20081008163622
#
# Table name: gmap_locations
#
#  id             :integer(11)     not null, primary key
#  locatable_id   :integer(11)     
#  locatable_type :string(255)     
#  latitude       :decimal(15, 10) 
#  longitude      :decimal(15, 10) 
#

class GmapLocation < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true
end
