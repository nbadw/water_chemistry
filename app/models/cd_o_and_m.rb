class CdOAndM < ActiveRecord::Base
  set_table_name  'cdOandM'
  set_primary_key 'oandmcd'
  
  alias_attribute :group, :oandm_group
  alias_attribute :name, :oandm_parameter
end
