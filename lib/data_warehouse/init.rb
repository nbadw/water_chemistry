require 'data_warehouse/acts_as_importable'
#require 'data_warehouse/acts_as_incorporated'
#require 'data_warehouse/acts_as_exportable'

ActiveRecord::Base.send :include, DataWarehouse::ActsAsImportable
#ActiveRecord::Base.send :include, DataWarehouse::ActsAsIncorporated