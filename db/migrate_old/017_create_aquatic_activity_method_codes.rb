class CreateAquaticActivityMethodCodes < ActiveRecord::Migration
  def self.up
    create_table :aquatic_activity_method_codes do |t|
      t.integer    :aquatic_activity_code
      t.string     :method
      t.timestamps
    end
  end

  def self.down
    drop_table :aquatic_activity_method_codes
  end
end
