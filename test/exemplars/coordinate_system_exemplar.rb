class CoordinateSystem < ActiveRecord::Base   
  generator_for(:epsg, :start => 1) { |prev| prev + 1 }
  generator_for :name => 'Test Coordinate System'
end
