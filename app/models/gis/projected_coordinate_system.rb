# == Schema Information
# Schema version: 20080923163956
#
# Table name: coordinate_systems
#
#  epsg         :integer(11)     not null, primary key
#  name         :string(100)     
#  display_name :string(40)      
#

class ProjectedCoordinateSystem < CoordinateSystem
end
