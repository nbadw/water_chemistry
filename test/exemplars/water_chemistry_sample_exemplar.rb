class WaterChemistrySample < ActiveRecord::Base
  generator_for :collection_method => WaterChemistrySample.collection_method_options.first
end