class CreateSampleResults < ActiveRecord::Migration
  def self.up
    create_table :sample_results do |t|
      t.integer :sample_id,    :null => false
      t.integer :parameter_id, :null => false
      t.float   :value
      t.string  :qualifier
      t.timestamps
    end
  end

  def self.down
    drop_table :sample_results
  end
end
