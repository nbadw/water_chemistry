class CoordinateSource < ActiveRecord::Base   
  generator_for(:name, :start => 'source0') { |prev| prev.succ }
end
