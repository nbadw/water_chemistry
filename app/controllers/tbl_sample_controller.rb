class TblSampleController < ApplicationController
  active_scaffold do |config|
    # base config
    config.label = "Samples"
    config.columns = [:agency_sample_no, :collection_method, :sample_depth_in_meters, 
      :water_source_type, :analyzed_by, :results]
    config.columns[:sample_depth_in_meters].label = "Sample Depth (m)"
    config.nested.add_link "Results", [:results]
    
    # list config
    config.list.columns.exclude :results
  end
end
