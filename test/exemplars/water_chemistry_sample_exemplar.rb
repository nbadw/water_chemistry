class WaterChemistrySample < ActiveRecord::Base
  generator_for :sample_collection_method => WaterChemistrySample.sample_collection_methods.first
end