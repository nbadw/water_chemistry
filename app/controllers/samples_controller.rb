class SamplesController < ApplicationController  
  before_filter :login_required
  
  active_scaffold :sample do |config|
    # base config
    config.label = "Samples"
    config.actions.exclude :search
    
    config.columns = [:id, :aquatic_activity_id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no, :sample_results]
    config.list.columns = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]
    config.show.columns = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]    
    [:create, :update].each do |action|
      config.send(action).columns = [:agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]       
    end    

    # labels
    config.columns[:id].label = "ADW Sample ID"
    config.columns[:sample_depth_m].label = "Sample Depth (m)"
    config.columns[:sample_results].label = "Parameters"
    config.columns[:agency_sample_no].label = "Agency Sample No."
    config.columns[:sample_collection_method].label = "Sample Collection Method"
    config.columns[:water_source_type].label = "Water Source Type"
    config.columns[:analyzed_by].label = "Analyzed By"
    config.columns[:lab_no].label = "Lab No."
    config.create.label = 'Add Sample'
    config.update.label = 'Update Sample'
    
    # descriptions
    config.columns[:analyzed_by].description = 'For analytical lab samples, enter the name of the lab performing the analysis'

    config.columns[:aquatic_activity_id].search_sql = "#{Sample.table_name}.#{Sample.column_for_attribute(:aquatic_activity_id).name}"    
    config.nested.add_link "Parameters", [:sample_results]
  end
  
  protected
  def self.active_scaffold_controller_for(klass)
    klass == WaterMeasurement ? RecordedChemicalsController : super
  end
  
  def find_current_aquatic_activity_event
    if active_scaffold_session_storage[:constraints] && active_scaffold_session_storage[:constraints][:aquatic_activity_id]      
      @current_aquatic_activity_event = AquaticActivityEvent.find(active_scaffold_session_storage[:constraints][:aquatic_activity_id])
    end
  end
  
  def create_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end
  
  def update_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end
  
  def delete_authorized?
    current_aquatic_activity_event_owned_by_current_agency?
  end
  
  def current_aquatic_activity_event_owned_by_current_agency?
    if current_agency && current_aquatic_activity_event
      current_agency == current_aquatic_activity_event.agency || current_agency == current_aquatic_activity_event.secondary_agency
    end
  end
end
