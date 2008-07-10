class UnitOfMeasure < ActiveRecord::Base
  set_table_name 'units_of_measure'  
  has_and_belongs_to_many :measurements, :join_table => 'measurement_unit'
  
  def name_and_unit
    "#{self.name} (#{self.unit})"
  end
end
