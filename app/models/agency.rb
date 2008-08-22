# == Schema Information
# Schema version: 1
#
# Table name: cdagency
#
#  id           :integer(11)     not null
#  agencycd     :string(5)       default(""), not null, primary key
#  agency       :string(60)      
#  agencytype   :string(4)       
#  datarulesind :string(1)       default("N")
#  created_at   :datetime        
#  updated_at   :datetime        
#  imported_at  :datetime        
#  exported_at  :datetime        
#

class Agency < ActiveRecord::Base  
  set_table_name  :cdagency
  set_primary_key :agencycd
  
  has_many :users
  has_many :aquatic_site_usages
  
  alias_attribute :code, :agencycd
  alias_attribute :name, :agency
  alias_attribute :agency_type, :agencytype
  alias_attribute :data_rules, :datarulesind
  
  validates_presence_of :name
  
  class << self
    def name_column
      :agency
    end
    
    def code_column
      :agencycd
    end
  end
end
