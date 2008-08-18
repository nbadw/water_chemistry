require File.dirname(__FILE__) + '/../test_helper'

class AgencyTest < ActiveSupport::TestCase
  should_use_table :cdagency
  should_use_primary_key :agencycd
  
  should_require_attributes :name
  should_have_many :users, :aquatic_site_usages 

  should_have_db_column  :agencycd, :type => :string, :limit => 5, :null => false  
  should_alias_attribute :agencycd, :code
  
  should_have_db_column  :agency, :type => :string, :limit => 60
  should_alias_attribute :agency, :name
  
  should_have_db_column  :agencytype, :type => :string, :limit => 4
  should_alias_attribute :agencytype, :agency_type
  
  should_have_db_column  :datarulesind, :type => :string, :limit => 1, :default => 'N'
  should_alias_attribute :datarulesind, :data_rules
  
  should_define_timestamps
  
  should_have_class_methods :name_column, :code_column
end
