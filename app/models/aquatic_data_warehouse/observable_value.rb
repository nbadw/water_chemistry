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

class ObservableValue < AquaticDataWarehouse::Base
end
