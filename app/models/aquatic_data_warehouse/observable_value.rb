# == Schema Information
# Schema version: 1
#
# Table name: cdOandMValues
#
#  OandMValuesCd :integer(10)     not null, primary key
#  OandMCd       :integer(10)     
#  Value         :string(20)      
#

class ObservableValue < AquaticDataWarehouse::BaseCd
  set_table_name 'cdOandMValues'
  set_primary_key 'OandMValuesCd'
  
  belongs_to :observation, :foreign_key => 'OandMCd'
end
