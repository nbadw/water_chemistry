class CreateEnhancementTables < ActiveRecord::Migration
  def self.models
    [:agency, :aquatic_activity, :aquatic_activity_event, :aquatic_activity_method, 
      :aquatic_site, :aquatic_site_usage, :instrument, :measurement, :observable_value,
      :observation, :site_measurement, :site_observation, :unit_of_measure, 
      :water_chemistry_parameter, :water_chemistry_sample, :water_chemistry_sample_result,
      :waterbody]
  end
  
  def self.up
#    models.each do |model|
#      create_table "#{model}_enhancements" do |t|
#        t.integer "#{model}_id", :null => false
#        t.timestamps
#        t.timestamp :imported_at
#        t.timestamp :exported_at
#        t.integer   :created_by
#        t.integer   :updated_by
#      end
#    end
    
    
  end

  def self.down
#    models.each do |model|
#      drop_table "#{model}_enhancements"
#    end
  end
end
