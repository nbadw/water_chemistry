class AddAuditFields < ActiveRecord::Migration
  def self.up
    tables.each do |table|
      add_column table, :created_at, :timestamp
      add_column table, :updated_at, :timestamp
      add_column table, :created_by, :integer
      add_column table, :updated_by, :integer
    end
  end

  def self.down
    tables.each do |table|
      remove_columns table, :created_at, :updated_at, :created_by, :updated_by
    end
  end
  
  private
  def self.tables
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.tables
  end
end
