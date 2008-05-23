class CreateAquaticActivityCodes < ActiveRecord::Migration
  def self.up
    create_table :aquatic_activity_codes do |t|
      t.string :activity
      t.string :category
      t.string :duration
      t.timestamps
    end
  end

  def self.down
    drop_table :aquatic_activity_codes
  end
end
