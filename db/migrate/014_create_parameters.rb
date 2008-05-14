class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.string 'name'
      t.string 'description'
      t.string 'parameter_type'
      t.string 'result'
      t.string 'unit_of_measure'
      t.text   'comment'
      t.string 'instrument_type'
      t.float  'detection_limit'
      t.integer 'sample_id'
      t.timestamps
    end
    add_index :parameters, 'sample_id'
  end

  def self.down
    drop_table :parameters
  end
end
