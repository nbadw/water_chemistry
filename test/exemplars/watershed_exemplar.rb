class Watershed < ActiveRecord::Base  
  generator_for(:drainage_code, :start => '01-00-00-00-00-00') do |prev|
    levels = prev.split('-')
    incremented = false
    levels.collect! do |level|
      if level < '99' && !incremented
        level.succ!
        incremented = true        
      end
      level
    end
    levels.join('-')
  end
end
