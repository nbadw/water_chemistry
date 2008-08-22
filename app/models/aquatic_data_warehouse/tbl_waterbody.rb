# == Schema Information
# Schema version: 1
#
# Table name: tblwaterbody
#
#  waterbodyid            :integer(11)     not null, primary key
#  cgndb_key              :string(10)      
#  cgndb_key_alt          :string(10)      
#  drainagecd             :string(17)      
#  waterbodytypecd        :string(4)       
#  waterbodyname          :string(55)      
#  waterbodyname_abrev    :string(40)      
#  waterbodyname_alt      :string(40)      
#  waterbodycomplexid     :integer(11)     
#  surveyed_ind           :string(1)       
#  flowsintowaterbodyid   :float           
#  flowsintowaterbodyname :string(40)      
#  flowintodrainagecd     :string(17)      
#  dateentered            :datetime        
#  datemodified           :datetime        
#

class TblWaterbody < ActiveRecord::Base  
  set_table_name  'tblwaterbody'
  set_primary_key 'waterbodyid'  
  
  has_many :aquatic_sites, :foreign_key => 'aquaticsiteid'
end
