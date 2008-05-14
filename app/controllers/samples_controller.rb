class SamplesController < ApplicationController
  layout 'admin'
  active_scaffold :sample do |config|
    config.columns = [:station, :field_number, :depth_in_meters, :medium, :from_date, :parameters]
  end
end
