require 'aquatic_data_warehouse/base'
require 'aquatic_data_warehouse/base_cd'
require 'aquatic_data_warehouse/base_tbl'
require 'aquatic_data_warehouse/aliases'
require 'aquatic_data_warehouse/incorporated'

AquaticDataWarehouse::Base.class_eval do
  include AquaticDataWarehouse::Aliases
  include AquaticDataWarehouse::Incorporated
end