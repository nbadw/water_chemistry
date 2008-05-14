class ParametersController < ApplicationController
  active_scaffold :parameter do |config|
    config.columns = [:name, :parameter_type, :result, :unit_of_measure, :description,
      :instrument_type, :detection_limit, :comment
    ]
  end
end
