class AquaticSite < ActiveRecord::Base
  generator_for :geom => Point.from_x_y(1, 2, 4326) 
end