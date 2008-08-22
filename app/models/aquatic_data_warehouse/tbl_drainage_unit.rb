# == Schema Information
# Schema version: 1
#
# Table name: tbldrainageunit
#
#  drainagecd   :string(17)      default(""), not null, primary key
#  level1no     :string(2)       
#  level1name   :string(40)      
#  level2no     :string(2)       
#  level2name   :string(50)      
#  level3no     :string(2)       
#  level3name   :string(50)      
#  level4no     :string(2)       
#  level4name   :string(50)      
#  level5no     :string(2)       
#  level5name   :string(50)      
#  level6no     :string(2)       
#  level6name   :string(50)      
#  unitname     :string(55)      
#  unittype     :string(4)       
#  borderind    :string(1)       
#  streamorder  :integer(11)     
#  area_ha      :float           
#  area_percent :float           
#  cgndb_key    :string(10)      
#  drainsinto   :string(40)      
#

class TblDrainageUnit < ActiveRecord::Base  
  set_table_name  'tbldrainageunit'
  set_primary_key 'drainagecd'
end
