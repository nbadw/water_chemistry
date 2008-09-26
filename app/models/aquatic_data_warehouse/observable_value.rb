# == Schema Information
# Schema version: 20080923163956
#
# Table name: cdOandMValues
#
#  OandMValuesCd :integer(10)     not null, primary key
#  OandMCd       :integer(10)     
#  Value         :string(20)      
#  created_at    :datetime        
#  updated_at    :datetime        
#  created_by    :integer(11)     
#  updated_by    :integer(11)     
#

class ObservableValue < AquaticDataWarehouse::BaseCd
  set_table_name 'cdOandMValues'
  set_primary_key 'OandMValuesCd'
  
  belongs_to :observation, :foreign_key => 'OandMCd'
end
