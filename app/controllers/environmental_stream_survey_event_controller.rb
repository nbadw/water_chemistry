class EnvironmentalStreamSurveyEventController < AquaticActivityEventController 
  active_scaffold :aquatic_activity_event do |config|
    # modified version of base config
    config.label = :aquatic_activity_event_label
    config.actions = [:create, :list, :show, :update, :delete, :nested, :subform]

    config.columns = [:aquatic_site_id, :aquatic_activity_cd, :aquatic_activity_method, :start_date, :agency, :weather_conditions, :water_level]
    config.list.columns = [:start_date, :agency]
    config.show.columns = [:start_date, :agency]
    config.create.columns = [:start_date, :agency]
    config.update.columns = [:start_date, :agency]

    config.columns[:aquatic_site_id].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_site_id).name}"
    config.columns[:aquatic_activity_cd].search_sql = "#{AquaticActivityEvent.table_name}.#{AquaticActivityEvent.column_for_attribute(:aquatic_activity_cd).name}"

    # i18n labels
    config.columns[:aquatic_site_id].label         = :aquatic_site_id_label
    config.columns[:aquatic_activity_cd].label     = :aquatic_activity_cd_label
    config.columns[:start_date].label              = :start_date_label
    config.columns[:agency].label                  = :agency_label

    # action link labels
    config.create.label    = "Add Environmental Stream Survey Event"
    config.update.label    = "Update Environmental Stream Survey Event"
    config.show.link.label = :aquatic_activity_event_show_label

    # required fields
    config.columns[:start_date].required = true

    # list config
    config.columns[:start_date].sort_by :method => "#{self.name}.to_s"
    config.list.sorting = [{ :start_date => :desc }]

    # show config
    config.show.link.inline = false
    config.show.link.controller = 'environmental_stream_survey'
    config.show.link.action = 'surveys'
    # XXX: added so this action can be overridden in helper
    config.show.link.parameters = { :environmental_stream_surveys_link => true }

    # remove agency association auto-link
    config.columns[:agency].clear_link

    # link to allow adding/editing of an agency's site id
    config.action_links.add 'edit_agency_site_id',
      :label => :edit_agency_site_id_label,
      :type => :table,
      :inline => true
  end
end
