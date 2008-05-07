class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies, :id => false do |t|
      t.column  :id, 'varchar(10) primary key', :null => false
      t.string  :name
      t.string  :agency_type
      t.boolean :data_rules
      t.timestamps
    end
  end

  def self.down
    drop_table :agencies
  end
end
