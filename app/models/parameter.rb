class Parameter < ActiveRecord::Base
  has_many :sample_results
  
  validates_presence_of :name, :code
  validates_uniqueness_of :name
end
