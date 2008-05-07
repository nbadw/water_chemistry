class JoinUsersToAgency < ActiveRecord::Migration
  def self.up
    add_column :users, :agency_id, :integer
  end

  def self.down
    remove_column :users, :agency_id
  end
end
