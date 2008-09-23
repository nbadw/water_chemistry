# == Schema Information
# Schema version: 1
#
# Table name: cdInstrument
#
#  InstrumentCd        :integer(10)     not null, primary key
#  Instrument          :string(50)      
#  Instrument_Category :string(50)      
#

class Instrument < AquaticDataWarehouse::BaseCd
  set_primary_key 'InstrumentCd'
  has_and_belongs_to_many :measurements, :join_table => 'cdmeasureinstrument', :foreign_key => 'InstrumentCd', :association_foreign_key => 'OandMCd'
  
  def name
    instrument.to_s
  end
end
