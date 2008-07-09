class Waterbody < ActiveRecord::Base  
  has_many :aquatic_sites
    
  def self.search(query)
    search_conditions = ['name LIKE ? OR drainage_code LIKE ? OR id LIKE ?', "%#{query}%", "#{query}%", "#{query}%"]
    self.find :all, :conditions => search_conditions, :order => "name ASC"
  end
end
