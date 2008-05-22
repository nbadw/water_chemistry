require 'text'
require 'data_warehouse/acts_as_importable'
#require 'data_warehouse/acts_as_exportable'
#require 'data_warehouse/acts_as_incorporated'
ActiveRecord::Base.send :include, DataWarehouse::ActsAsImportable