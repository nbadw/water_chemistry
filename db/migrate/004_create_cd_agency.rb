class CreateCdAgency < ActiveRecord::Migration
  def self.up
    create_table "cdAgency", :id => false do |t|
      t.string "agencycd",     :limit => 10,  :null => false
      t.string "agency",       :limit => 120
      t.string "agencytype",   :limit => 8
      t.string "datarulesind", :limit => 2
    end
    execute "ALTER TABLE `cdAgency` ADD PRIMARY KEY (`agencycd`)" 
  end

  def self.down
    drop_table "cdAgency"
  end
end
