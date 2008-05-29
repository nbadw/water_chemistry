class CreateCdAquaticActivity < ActiveRecord::Migration
  def self.up    
    create_table "cdAquaticActivity", :primary_key => 'aquaticactivitycd' do |t|
      t.string  "aquaticactivity",         :limit => 100
      t.string  "aquaticactivitycategory", :limit => 60
      t.string  "duration",                :limit => 40
    end
  end

  def self.down
    drop_table "cdAquaticActivity"
  end
end
