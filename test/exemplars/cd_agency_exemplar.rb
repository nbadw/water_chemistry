class CdAgency < ActiveRecord::Base  
  class << self    
    attr_accessor :previous_id
    
    alias_method :original_spawn, :spawn    
    def spawn(args = {})      
      obj = original_spawn(args)
      obj.id = generate_id
      obj
    end
    
    def generate_id  
      next_id = (self.previous_id || 'AG0').succ
      self.previous_id = next_id
      next_id
    end
  end
  
  generator_for :name => 'AgencyName'
end
