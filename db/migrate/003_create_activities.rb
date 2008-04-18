class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|      
      t.string :name,  :null => false, :unique => true
      t.string :title, :null => false      
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
