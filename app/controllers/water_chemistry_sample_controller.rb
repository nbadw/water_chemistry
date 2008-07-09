class WaterChemistrySampleController < ApplicationController
  active_scaffold do |config|
    # base config
    config.label = "Samples"
    config.columns = [:agency_sample_no, :collection_method, :sample_depth_in_meters, 
      :water_source_type, :analyzed_by, :sample_results]
    config.columns[:sample_depth_in_meters].label = "Sample Depth (m)"
    config.columns[:sample_results].label = "Results"
    config.nested.add_link "Results", [:sample_results]
    
    # list config
    config.list.columns.exclude :sample_results
  end
end
