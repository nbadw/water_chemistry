class Agency < ActiveRecord::Base      
  has_many :users
  has_many :aquatic_site_usages
  validates_presence_of :name
end
