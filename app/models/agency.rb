class Agency < ActiveRecord::Base
  has_many :users
  
  validates_presence_of   :name, :code
  validates_uniqueness_of :code
  
  generator_for :name => 'AgencyName'
  generator_for(:code, :start => 'AG0') { |prev| prev.succ }
end
