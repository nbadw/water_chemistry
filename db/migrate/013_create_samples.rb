class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.string    'station'
      t.timestamp 'from_date'
      t.integer   'field_number'
      t.string    'medium'
      t.float     'depth_in_meters'
      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
