class SampleResultsController < ApplicationController
  before_filter :login_required
  
  active_scaffold do |config|
    config.label = "Results"
    config.list.columns = [:parameter_name, :parameter_code, :value, :qualifier]
  end
end
