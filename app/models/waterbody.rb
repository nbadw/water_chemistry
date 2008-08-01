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
  
  has_many :aquatic_sites
end
