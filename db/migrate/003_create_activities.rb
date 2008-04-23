class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|      
      t.string    :name,      :null => false, :unique => true
      t.string    :title,     :null => false
      t.text      :desc
      t.string    :author
      t.geometry  :geom,      :srid => 4326, :with_z => false
      t.string    :type      
      t.integer   :agency_id, :null => false
      
      t.integer   :version
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :activities, :geom, :spatial => true
  end

  def self.down
    drop_table :activities
  end
end
