# == Schema Information
# Schema version: 2
#
# Table name: tblaquaticsite
#
#  aquaticsiteid             :integer(11)     not null, primary key
#  oldaquaticsiteid          :integer(11)     
#  riversystemid             :integer(11)     
#  waterbodyid               :integer(11)     
#  waterbodyname             :string(50)      
#  aquaticsitename           :string(100)     
#  aquaticsitedesc           :string(250)     
#  habitatdesc               :string(50)      
#  reachno                   :integer(11)     
#  startdesc                 :string(100)     
#  enddesc                   :string(100)     
#  startroutemeas            :float           
#  endroutemeas              :float           
#  sitetype                  :string(20)      
#  specificsiteind           :string(1)       
#  georeferencedind          :string(1)       
#  dateentered               :datetime        
#  incorporatedind           :boolean(1)      
#  coordinatesource          :string(50)      
#  coordinatesystem          :string(50)      
#  xcoordinate               :string(50)      
#  ycoordinate               :string(50)      
#  coordinateunits           :string(50)      
#  comments                  :string(50)      
#  gmap_latitude             :decimal(15, 10) 
#  gmap_longitude            :decimal(15, 10) 
#  imported_at               :datetime        
#  exported_at               :datetime        
#  created_at                :datetime        
#  updated_at                :datetime        
#  gmap_coordinate_system_id :integer(11)     
#  coordinate_system_id      :integer(11)     
#  coordinate_source_id      :integer(11)     
#

class TblAquaticSite < ActiveRecord::Base      
  set_table_name  'tblaquaticsite'
  set_primary_key 'aquaticsiteid'  
end
