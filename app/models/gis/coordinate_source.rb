class CoordinateSource < ActiveRecord::Base
  has_and_belongs_to_many :coordinate_systems
  validates_presence_of   :name
  validates_uniqueness_of :name
end
