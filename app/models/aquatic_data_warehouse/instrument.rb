# == Schema Information
# Schema version: 1
#
# Table name: instruments
#
#  id          :integer(11)     not null, primary key
#  name        :string(100)     
#  category    :string(100)     
#  imported_at :datetime        
#  exported_at :datetime        
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Instrument < AquaticDataWarehouse::BaseCd
  set_primary_key 'InstrumentCd'
  has_and_belongs_to_many :measurements, :join_table => 'cdmeasureinstrument', :foreign_key => 'InstrumentCd', :association_foreign_key => 'OandMCd'
end
