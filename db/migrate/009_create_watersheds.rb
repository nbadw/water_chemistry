class CreateWatersheds < ActiveRecord::Migration   
  def self.up
    create_table :watersheds, :id => false do |t|
      t.column  "id", "varchar(17) primary key", :null => false
      t.string  "name"
      t.string  "unit_type"
      t.boolean "border"
      t.integer "stream_order"
      t.float   "area_ha"
      t.float   "area_percent"
      t.string  "drains_into"
      6.times do |i|        
        t.string "level#{i+1}_no"
        t.string "level#{i+1}_name"
      end
      t.timestamps
    end
  end

  def self.down
    drop_table :watersheds
  end  
end
