# == Schema Information
# Schema version: 1
#
# Table name: roles
#
#  id         :integer(11)     not null, primary key
#  rolename   :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Role < ActiveRecord::Base
  has_many :permissions
  has_many :users, :through => :permissions
  
  validates_presence_of   :rolename
  validates_uniqueness_of :rolename
  
  generator_for(:rolename, :start => 'role') { |prev| prev.succ }
end
