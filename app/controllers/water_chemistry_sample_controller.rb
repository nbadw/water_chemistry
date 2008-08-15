class WaterChemistrySampleController < ApplicationController
  active_scaffold do |config|
    # base config
    config.label = "Samples"
    config.actions.exclude :search
    config.columns = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_in_m, :water_source_type, :analyzed_by, :water_chemistry_sample_results]
    config.columns.each { |column| column.label = column.label.titleize }
    config.columns[:id].label = "Sample ID"
    config.columns[:sample_depth_in_m].label = "Sample Depth (m)"
    config.columns[:water_chemistry_sample_results].label = "Parameters"
    config.nested.add_link "Parameters", [:water_chemistry_sample_results]
    
    # list config
    config.list.columns.exclude :water_chemistry_sample_results
    config.list.sorting =[{ :created_at => :asc }]
    
    # show config
    config.show.columns.exclude :water_chemistry_sample_results
  end
end
