class Measurement < ActiveRecord::Base  
  has_and_belongs_to_many :instruments, :join_table => 'measurement_instrument'
  has_and_belongs_to_many :units_of_measure, :join_table => 'measurement_unit', :class_name => 'UnitOfMeasure', :association_foreign_key => 'unit_of_measure_id'
end
