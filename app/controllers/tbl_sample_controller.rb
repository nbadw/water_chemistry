class TblSampleController < ApplicationController
  active_scaffold do |config|
    # base config
    config.label = "Samples"
    config.columns = [:agency_sample_no, :sample_depth_in_meters, :water_source_type,
      :analyzed_by]
  end
end
