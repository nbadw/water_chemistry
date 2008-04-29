class Role < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  
  validates_presence_of   :rolename
  validates_uniqueness_of :rolename
  
  generator_for(:rolename, :start => 'role') { |prev| prev.succ }
end
