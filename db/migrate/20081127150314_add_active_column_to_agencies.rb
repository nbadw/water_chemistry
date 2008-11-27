class AddActiveColumnToAgencies < ActiveRecord::Migration
  def self.up
    add_column 'cdAgency', :active, :boolean, :default => true
  end

  def self.down
    remove_column 'cdAgency', :active
  end
end
