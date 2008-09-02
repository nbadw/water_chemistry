# == Schema Information
# Schema version: 1
#
# Table name: observable_values
#
#  id             :integer(11)     not null, primary key
#  observation_id :integer(11)     
#  value          :string(255)     
#  imported_at    :datetime        
#  exported_at    :datetime        
#  created_at     :datetime        
#  updated_at     :datetime        
#

class ObservableValue < AquaticDataWarehouse::BaseCd
  set_table_name 'cdOandMValues'
  set_primary_key 'OandMValuesCd'
  
  belongs_to :observation, :foreign_key => 'OandMCd'
end
