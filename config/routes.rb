ActionController::Routing::Routes.draw do |map| 
  # MAIN ROUTES
  map.root :controller => "data_entry", :action => "browse"  
  map.browse   '/browse',       :controller => 'data_entry', :action => 'browse'
  map.explore  '/explore',      :controller => 'data_entry', :action => 'explore'
  
  # USER & ACCOUNT ROUTES
  map.signup   '/signup',       :controller => 'users',      :action => 'new'
  map.login    '/login',        :controller => 'sessions',   :action => 'new'
  map.logout   '/logout',       :controller => 'sessions',   :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts',   :action => 'show'  
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'    
  map.resources :users  
  map.resource :session
  map.resource :password  
  
  # ADMIN ROUTES
  map.namespace :admin do |admin|
    admin.home '', :controller => 'admin', :action => 'index'
    code_tables = [:agencies, :aquatic_activities, :aquatic_activity_methods, :instruments,
      :observable_values, :qualifiers, :sample_collection_methods, :units_of_measure,
      :water_sources, :observations, :measurements, :users]    
    code_tables.each do |code_table|
      admin.resources code_table, :active_scaffold => true
    end
  end
    
  ######################
  # APPLICATION ROUTES #
  ######################
    
  # DATA COLLECTION SITE ROUTES
  map.connect '/data_collection_sites/on_preview_location', :controller => 'data_collection_sites', :action => 'on_preview_location'
  map.connect '/data_collection_sites/report', :controller => 'data_collection_sites', :action => 'report'
  map.connect '/data_collection_sites/report.:format', :controller => 'data_collection_sites', :action => 'report'
  map.resources :data_collection_sites, :active_scaffold => true do |sites|
    sites.resources :data_sets, :active_scaffold => true
  end
    
  # AQUATIC ACTIVITY ROUTES  
  map.connect '/aquatic_activity/site_aquatic_activities', :controller => 'aquatic_activity', :action => 'site_aquatic_activities'  
  map.connect '/aquatic_activity/aquatic_activity_details', :controller => 'aquatic_activity', :action => 'aquatic_activity_details'  
  
  # WATER CHEMISTRY SAMPLING ROUTES
  map.connect '/aquatic_site/:aquatic_site_id/water_chemistry_sampling/:aquatic_activity_event_id/:action', :controller => 'water_chemistry_sampling'
  map.connect '/aquatic_site/:aquatic_site_id/water_chemistry_sampling/:aquatic_activity_event_id/report.:format', :controller => 'water_chemistry_sampling', :action => 'report'  
  
  # OTHER ROUTES
  map.resources :recorded_chemicals, :active_scaffold => true
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
