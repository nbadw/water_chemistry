class Activity < ActiveRecord::Base  
  generator_for(:name, :start => 'ActivityName0') { |prev| prev.succ }
  generator_for :category => 'Category'
end
