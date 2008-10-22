# == Schema Information
# Schema version: 20081008163622
#
# Table name: coordinate_systems
#
#  epsg         :integer(11)     not null, primary key
#  name         :string(100)     
#  display_name :string(40)      
#

class CoordinateSystem < ActiveRecord::Base
  set_primary_key :epsg
  
  has_and_belongs_to_many :coordinate_sources
end
