class Measurement < ActiveRecord::Base   
  generator_for(:name, :start => 'Measurement0') { |prev| prev.succ }
end
