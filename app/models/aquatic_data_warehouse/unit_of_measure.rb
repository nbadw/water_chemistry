# == Schema Information
# Schema version: 1
#
# Table name: cdUnitofMeasure
#
#  UnitofMeasureCd  :integer(10)     not null, primary key
#  UnitofMeasure    :string(50)      
#  UnitofMeasureAbv :string(10)      
#

class UnitOfMeasure < AquaticDataWarehouse::BaseCd
  set_table_name  'cdUnitofMeasure'
  set_primary_key 'UnitofMeasureCd'
  has_and_belongs_to_many :measurements, :join_table => 'cdmeasureunit', :foreign_key => 'UnitofMeasureCd', :association_foreign_key => 'OandMCd'
  
  alias_attribute :name, :unitof_measure
  alias_attribute :abbrev, :unitof_measure_abv
  
  def name_and_unit
    "#{name} (#{abbrev})"
  end
end
