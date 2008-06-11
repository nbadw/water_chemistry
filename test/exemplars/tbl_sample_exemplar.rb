class TblSample < ActiveRecord::Base
  generator_for :collection_method => TblSample.collection_method_options.first
end