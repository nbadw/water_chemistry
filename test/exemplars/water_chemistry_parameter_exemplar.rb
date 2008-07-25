class WaterChemistryParameter < ActiveRecord::Base  
  generator_for(:name, :start => 'param0') { |prev| prev.succ }
  generator_for :code => 'XXX'
end
