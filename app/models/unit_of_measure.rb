# == Schema Information
# Schema version: 1
#
# Table name: units_of_measure
#
#  id          :integer(11)     not null, primary key
#  name        :string(100)     
#  unit        :string(20)      
#  imported_at :datetime        
#  exported_at :datetime        
#  created_at  :datetime        
#  updated_at  :datetime        
#

class UnitOfMeasure < ActiveRecord::Base
  set_table_name 'units_of_measure'  
  has_and_belongs_to_many :measurements, :join_table => 'measurement_unit'
  
  def name_and_unit
    "#{self.name} (#{self.unit})"
  end
end
