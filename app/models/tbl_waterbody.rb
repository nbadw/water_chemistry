class TblWaterbody < ActiveRecord::Base
  set_table_name  'tblWaterBody'
  set_primary_key 'waterbodyid'

  alias_attribute :name, :waterbodyname
  alias_attribute :drainage_code, :drainagecd
  
  has_many :aquatic_sites, :class_name => 'TblAquaticSite', :foreign_key => 'waterbodyid'
    
  def self.search(query)
    search_conditions = ['waterbodyname LIKE ? OR drainagecd LIKE ? OR waterbodyid LIKE ?', "%#{query}%", "#{query}%", "#{query}%"]
    self.find :all, :limit => 10, :conditions => search_conditions, :order => "waterbodyname ASC"
  end
end
