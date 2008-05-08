class Watershed < ActiveRecord::Base    
  class << self    
    attr_accessor :previous_id
    
    alias_method :original_spawn, :spawn    
    def spawn(args = {})      
      obj = original_spawn(args)
      obj.id = generate_id
      obj
    end
    
    def generate_id      
      levels = (self.previous_id || '01-00-00-00-00-00').split('-')
      incremented = false
      levels.collect! do |level|
        if level < '99' && !incremented
          level.succ!
          incremented = true        
        end
        level
      end
      next_id = levels.join('-')      
      self.previous_id = next_id
      next_id
    end
  end
end
