class AddFishPassageIndicators < ActiveRecord::Migration
  class Observation < ActiveRecord::Base
    set_table_name  'cdOandM'
    set_primary_key 'OandMCd'
  end
  
  def self.up
    modify_observations do |observation|      
      observation.write_attribute('FishPassageInd', true)
      observation.save!
    end
  end

  def self.down
    modify_observations do |observation|
      observation.write_attribute('FishPassageInd', false)
      observation.save!
    end
  end
  
  private 
  def self.modify_observations
    obs_ids = [23, 25, 29, 31, 49, 50, 51, 52, 179]
    Observation.find(obs_ids).each do |observation|
      yield observation
    end
  end
end
