class CoordinateSystem < ActiveRecord::Base
  validates_presence_of     :epsg, :name
  validates_uniqueness_of   :epsg
  validates_numericality_of :epsg, :only_integer => true
  
  def display_name
    name.to_s.gsub('_', ' ').downcase.titleize  
  end
end
