class DataCollectionSitesController < ApplicationController  
  layout 'admin'
  active_scaffold do |config|
    
    config.list.sorting =[{ :drainage_code => :asc }]
  end
end
