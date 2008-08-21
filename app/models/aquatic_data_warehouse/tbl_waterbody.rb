# == Schema Information
# Schema version: 2
#
# Table name: waterbodies
#
#  id                      :integer(11)     not null, primary key
#  drainage_code           :string(17)      
#  waterbody_type          :string(8)       
#  name                    :string(110)     
#  abbreviated_name        :string(80)      
#  alt_name                :string(80)      
#  waterbody_complex_id    :integer(11)     
#  surveyed                :boolean(1)      
#  flows_into_waterbody_id :integer(11)     
#  imported_at             :datetime        
#  exported_at             :datetime        
#  created_at              :datetime        
#  updated_at              :datetime        
#

class TblWaterbody < ActiveRecord::Base  
  set_table_name  'tblwaterbody'
  set_primary_key 'waterbodyid'
end
