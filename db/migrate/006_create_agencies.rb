class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies, :id => false do |t|
      t.string  :code, :limit => 10, :null => false
      t.string  :name
      t.string  :agency_type
      t.boolean :data_rules
      t.timestamps
    end
    execute "ALTER TABLE `agencies` ADD PRIMARY KEY (`code`)"
  end

  def self.down
    drop_table :agencies
  end
end
