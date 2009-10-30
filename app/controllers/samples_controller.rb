class SamplesController < ApplicationController  
  before_filter :login_required
  
  active_scaffold :sample do |config|
    # base config
    config.actions.exclude :search
    
    config.columns        = [:id, :aquatic_activity_id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no, :sample_results]
    config.list.columns   = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]
    config.show.columns   = [:id, :agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]
    config.create.columns = [:agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]
    config.update.columns = [:agency_sample_no, :sample_collection_method, :sample_depth_m, :water_source_type, :analyzed_by, :lab_no]

    # i18n labels
    config.label                                    = :samples_label
    config.create.label                             = :samples_create_label
    config.update.label                             = :samples_update_label
    config.columns[:id].label                       = :samples_id_label
    config.columns[:agency_sample_no].label         = :samples_agency_sample_no_label
    config.columns[:sample_collection_method].label = :samples_sample_collection_method_label
    config.columns[:sample_depth_m].label           = :samples_sample_depth_m_label
    config.columns[:water_source_type].label        = :samples_water_source_type_label
    config.columns[:analyzed_by].label              = :samples_analyzed_by_label
    config.columns[:lab_no].label                   = :samples_lab_no_label
    config.columns[:sample_results].label           = :samples_sample_results_label
    
    # descriptions
    config.columns[:analyzed_by].description = :samples_analyzed_by_desc

    config.columns[:aquatic_activity_id].search_sql = 
      "#{Sample.table_name}.#{Sample.column_for_attribute(:aquatic_activity_id).name}"

    config.nested.add_link config.columns[:sample_results].label, [:sample_results]
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
