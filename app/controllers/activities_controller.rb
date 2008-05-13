class ActivitiesController < ApplicationController
  active_scaffold :activity do |config|
    config.columns = [:name, :category, :duration]
  end
end