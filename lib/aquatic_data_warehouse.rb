require 'aquatic_data_warehouse/base'
require 'aquatic_data_warehouse/base_cd'
require 'aquatic_data_warehouse/base_tbl'

require 'aquatic_data_warehouse/aliases'
require 'aquatic_data_warehouse/incorporated_model'

require 'rails_generator'
require 'rails_generator/scripts/generate'
require 'aquatic_data_warehouse/generators/schema/schema_generator'

AquaticDataWarehouse::Base.class_eval do
  include AquaticDataWarehouse::Aliases
  include AquaticDataWarehouse::Incorporated
end