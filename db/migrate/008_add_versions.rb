class AddVersions < ActiveRecord::Migration
  def self.up
    Activity.create_versioned_table
  end

  def self.down
    Activity.drop_versioned_table
  end
end
