require 'aquatic_data_warehouse/base'
require 'aquatic_data_warehouse/base_cd'
require 'aquatic_data_warehouse/base_tbl'
require 'aquatic_data_warehouse/aliases'
require 'aquatic_data_warehouse/security'
require 'aquatic_data_warehouse/validations'

AquaticDataWarehouse::Base.class_eval do
  include AquaticDataWarehouse::Aliases
  include AquaticDataWarehouse::Security
  include AquaticDataWarehouse::Validations
end