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

class UnitOfMeasure < AquaticDataWarehouse::BaseCd
  set_table_name  'cdUnitofMeasure'
  set_primary_key 'UnitofMeasureCd'
  has_and_belongs_to_many :measurements, :join_table => 'cdmeasureunit', :foreign_key => 'UnitofMeasureCd', :association_foreign_key => 'OandMCd'
  
  alias_attribute :name, :unitof_measure
  alias_attribute :abbrev, :unitof_measure_abv
  
  def name_and_unit
    "#{name} (#{unit})"
  end
end
