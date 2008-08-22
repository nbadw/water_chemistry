# == Schema Information
# Schema version: 1
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

class Waterbody < ActiveRecord::Base  
  class << self 
    def drainage_code_column
      :drainage_code
    end
    
    def name_column
      :name
    end
    
    def search(query)
      search_conditions = ['name LIKE ? OR drainage_code LIKE ? OR id LIKE ?', "%#{query}%", "#{query}%", "#{query}%"]
      self.find :all, :conditions => search_conditions, :order => "name ASC"
    end
  end
  
  has_many :aquatic_sites, :foreign_key => 'aquaticsiteid'
end
