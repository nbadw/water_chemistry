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
