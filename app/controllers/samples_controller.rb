class SamplesController < ApplicationController  
  before_filter :login_required
  
  active_scaffold :sample do |config|
    # base config
    config.label = "Samples"
    config.actions.exclude :search
    
    config.columns = [:id, :aquatic_activity_id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :sample_results]
    config.list.columns = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by]
    config.show.columns = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by]    
    config.create.columns = [:agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by] 
    
    config.create.columns.exclude :sample_results
    
    config.columns[:id].label = "Sample ID"
    config.columns[:sample_depth_m].label = "Sample Depth (m)"
    config.columns[:sample_results].label = "Parameters"
    config.columns[:agency_sample_no].label = "Sample No."
    config.columns[:sample_collection_method].label = "Sample Collection Method"
    config.columns[:water_source_type].label = "Water Source Type"
    config.columns[:analyzed_by].label = "Analyzed By"
    
    config.columns[:aquatic_activity_id].search_sql = "#{Sample.table_name}.#{Sample.column_for_attribute(:aquatic_activity_id).name}"    
    config.nested.add_link "Parameters", [:sample_results]
    
    #config.list.sorting =[{ :created_at => :asc }]    
  end
  
  protected
  def self.active_scaffold_controller_for(klass)
    klass == WaterMeasurement ? RecordedChemicalsController : super
  end
end
