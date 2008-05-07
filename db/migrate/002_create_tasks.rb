class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string  :title,       :null => false
      t.integer :position,    :null => false
      t.integer :activity_id, :null => false
      t.string  :controller,  :null => false
      t.string  :action,      :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
