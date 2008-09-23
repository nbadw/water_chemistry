class CreateAdw < ActiveRecord::Migration
  def self.up    
    run_script File.join(RAILS_ROOT, 'db', 'adw_create.sql')
  end

  def self.down
    run_script File.join(RAILS_ROOT, 'db', 'adw_drop.sql')
  end
  
  private 
  def self.run_script(filename)
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    username = config['username']
    password = config['password']
    database = config['database']
    filename = File.expand_path(filename)
    command = "mysql --user=#{username} --password=#{password} #{database} < \"#{filename}\""
    ok = system(command)
    raise "Could not execute command '#{command}'.  Please make sure the command is on your environment PATH." unless ok
  end
end
