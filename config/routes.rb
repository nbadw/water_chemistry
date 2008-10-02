ActionController::Routing::Routes.draw do |map| 
  map.resources :data_collection_sites, :active_scaffold => true do |sites|
    sites.resources :data_sets, :active_scaffold => true
  end
  
  map.resources :recorded_chemicals, :active_scaffold => true
  
  map.namespace :admin do |admin|
    admin.resources :aquatic_site, :active_scaffold => true
    admin.resources :agencies, :active_scaffold => true
  end
  
  map.root :controller => "data_entry", :action => "browse"  
  map.connect '/aquatic_activity/site_aquatic_activities', :controller => 'aquatic_activity', :action => 'site_aquatic_activities'  
  map.connect '/aquatic_activity/aquatic_activity_details', :controller => 'aquatic_activity', :action => 'aquatic_activity_details'  
  map.connect '/aquatic_site/:aquatic_site_id/water_chemistry_sampling/:aquatic_activity_event_id/:action', :controller => 'water_chemistry_sampling'  
  
  map.connect '/aquatic_site/report/:id', :controller => 'data_collection_sites', :action => 'water_chemistry_sampling_report'
  
  map.browse   '/browse',       :controller => 'data_entry', :action => 'browse'
  map.explore  '/explore',      :controller => 'data_entry', :action => 'explore'
  
  map.signup   '/signup',       :controller => 'users',      :action => 'new'
  map.login    '/login',        :controller => 'sessions',   :action => 'new'
  map.logout   '/logout',       :controller => 'sessions',   :action => 'destroy'
  map.activate '/activate/:id', :controller => 'accounts',   :action => 'show'  
  map.forgot_password '/forgot_password',    :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id', :controller => 'passwords', :action => 'edit'    
  map.resources :users  
  map.resource :session
  map.resource :password
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
