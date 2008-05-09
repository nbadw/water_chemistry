class JoinUsersToAgency < ActiveRecord::Migration
  def self.up
    add_column :users, :agency_code, :string
  end

  def self.down
    remove_column :users, :agency_code
  end
end
