class AddLanguageColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :language, :string, :default => 'en', :limit => 2
  end

  def self.down
    remove_column :users, :language
  end
end
