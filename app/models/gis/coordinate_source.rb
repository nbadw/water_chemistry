# == Schema Information
# Schema version: 20081008163622
#
# Table name: coordinate_sources
#
#  id   :integer(11)     not null, primary key
#  name :string(30)      
#

class CoordinateSource < ActiveRecord::Base 
  has_and_belongs_to_many :coordinate_systems
end
