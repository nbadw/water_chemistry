class AddAreaOfInterestColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, 'area_of_interest_id', :integer
  end

  def self.down
    remove_column :users, 'area_of_interest_id'
  end
end
