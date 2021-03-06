require "highline"
require "forwardable"
require "agency"
require "observation"
require "measurement"
require "gmap_location"
require "geo_ruby"

module AquaticDataWarehouse
  class Setup      
    include GeoRuby::Shp4r
    
    class << self
      def bootstrap(config)
        setup = new
        setup.bootstrap(config)
        setup
      end
    end
    
    attr_accessor :config  
    
    def bootstrap(config) 
      announce "Populating database tables (this may take awhile...)"
      populate_aquatic_data_warehouse  
      populate_coordinate_systems
      populate_coordinate_sources 
      populate_coordinate_sources_coordinate_systems
      create_admin_user(config[:admin_name], config[:admin_username], config[:admin_password], config[:admin_email], config[:admin_agency])  
      announce "Finished.\n\n"
    end
        
    private   
    def create_admin_user(name, username, password, email, agency)      
      unless name and username and password
        announce "Create the admin user (press enter for defaults)."
        name = prompt_for_admin_name unless name
        username = prompt_for_admin_username unless username
        password = prompt_for_admin_password unless password
        email = prompt_for_admin_email unless email
        agency = prompt_for_admin_agency unless agency
      end
      attributes = {
        :name => name,
        :login => username,
        :password => password,
        :password_confirmation => password,
        :email => email,
        :admin => true,
        :agency => Agency.find(agency)
      }
      admin = User.find_by_login(username) || User.new      
      admin.update_attributes(attributes)
      admin.send(:activate!)
      admin
    end
    
    def populate_coordinate_systems
      coordinate_systems = [
        { :epsg => 4326,  :display_name => 'WGS84' },
        { :epsg => 4269,  :display_name => 'NAD83' },
        { :epsg => 2036,  :display_name => 'NAD83 (CSRS) NB Stereographic' },
        { :epsg => 2200,  :display_name => 'ATS77 NB Stereographic' },
        { :epsg => 26919, :display_name => 'NAD83 / UTM zone 19N' },
        { :epsg => 26920, :display_name => 'NAD83 / UTM zone 20N' },
        { :epsg => 26719, :display_name => 'NAD27 / UTM zone 19N' },
        { :epsg => 26720, :display_name => 'NAD27 / UTM zone 20N' }
      ]
      
      coordinate_systems.each do |system|
        coordinate_system = CoordinateSystem.new(system)
        coordinate_system.id = system[:epsg]
        coordinate_system.save
      end
    end
    
    def populate_coordinate_sources
      coordinate_sources = [        
        { :name => "1:50,000 NTS Topographic Map" },
        { :name => "GIS" },
        { :name => "GPS" }
      ]
      
      coordinate_sources.each_with_index do |source, i|
        coordinate_source = CoordinateSource.new(source)
        coordinate_source.id = i + 1
        coordinate_source.save
      end
    end
    
    def populate_coordinate_sources_coordinate_systems
      source2system = { 
        "1:50,000 NTS Topographic Map" => [26919, 26920, 26719, 26720],
        "GIS" => [2036, 2200],
        "GPS" => [4326, 4269]       
      }
      
      source2system.each do |name, epsgs|
        source  = CoordinateSource.find_by_name(name)
        CoordinateSystem.find(epsgs).each { |system| source.coordinate_systems << system }
        source.save!
      end
    end
    
    def populate_aquatic_data_warehouse
      import_script = File.join(RAILS_ROOT, 'db', 'adw_import.sql')
      db_config = ActiveRecord::Base.configurations[RAILS_ENV]      
      raise 'Bootstrap task currently only works with MySQL' unless db_config['adapter'] == 'mysql'
      
      username = db_config['username']
      password = db_config['password']
      database = db_config['database']
      filename = File.expand_path(import_script) 
      command = "mysql --user=#{username} --password=#{password} #{database} < \"#{filename}\""
      
      ok = system(command)
      raise "Could not execute command '#{command}'.  Please make sure the command is on your environment PATH." unless ok   
      
      ActiveRecord::Base.establish_connection
      fix_boolean_column_values
      set_fish_passage_indicators
      set_bank_indicators
      load_aquatic_site_coordinates
      add_richibucto_river_association_agency
    end
    
    def add_richibucto_river_association_agency
      agency = Agency.new(
        :agency => 'Richibucto River Watershed',
        :agency_type => 'NGO',
        :data_rules_ind => 'N'
      )
      agency.id = 'RICH'
      agency.save!
    end
    
    def fix_boolean_column_values      
      to_be_fixed = []
      ActiveRecord::Base.connection.tables.each do |table|
        ar_model = Class.new(ActiveRecord::Base) { set_table_name table }
        ar_model.columns.each { |column| to_be_fixed << { :table => table, :column => column.name } if column.type == :boolean }
      end
      to_be_fixed.each do |fix|
        update = "UPDATE `#{fix[:table]}` SET `#{fix[:column]}` = 1 WHERE `#{fix[:column]}` = -1;"
        ActiveRecord::Base.connection.execute(update)
      end
    end
    
    def set_fish_passage_indicators
      obs_ids = [23, 25, 29, 31, 49, 50, 51, 52, 179]
      Observation.find(obs_ids).each do |observation|
        observation.write_attribute('FishPassageInd', true)
        observation.save!
      end
    end

    def set_bank_indicators
      meas_ids = [74, 75]
      Measurement.find(meas_ids).each do |measurement|
        measurement.write_attribute('BankInd', true)
        measurement.save!
      end
    end
    
    def load_aquatic_site_coordinates
      shape_file = File.join(RAILS_ROOT, 'db', 'aquatic_site_locations', 'Aquatic_Sites.shp')
      ShpFile.open(shape_file) do |shpfile|
        shpfile.each do |shape| 
          if(shape.geometry.text_geometry_type == 'POINT')
            gmap_location = GmapLocation.create({
                :latitude  => shape.geometry.lat,
                :longitude => shape.geometry.lon,
                :locatable_id => shape.data['AquaSiteID'],
                :locatable_type => 'AquaticSite'
              })            
          end             
        end
      end
    end
    
    def prompt_for_admin_name
      username = ask('Name (Administrator): ', String) do |q|
        q.validate = /^(|.{1,100})$/
        q.responses[:not_valid] = "Invalid name. Must be at less than 100 characters long."
        q.whitespace = :strip
      end
      username = "Administrator" if username.blank?
      username
    end
      
    def prompt_for_admin_username
      username = ask('Username (admin): ', String) do |q|
        q.validate = /^(|.{3,40})$/
        q.responses[:not_valid] = "Invalid username. Must be at least 3 characters long."
        q.whitespace = :strip
      end
      username = "admin" if username.blank?
      username
    end
      
    def prompt_for_admin_password
      password = ask('Password (DEapp): ', String) do |q|
        #q.echo = false
        q.validate = /^(|.{4,40})$/
        q.responses[:not_valid] = "Invalid password. Must be at least 5 characters long."
        q.whitespace = :strip
      end
      password = "DEapp" if password.blank?
      password
    end
    
    def prompt_for_admin_email
      email = ask('Email: ', String) do |q|
        q.validate = /^.{3,100}$/
        q.responses[:not_valid] = "Invalid email. Must be at least 3 characters long."
        q.whitespace = :strip
      end
      email
    end
    
    def prompt_for_admin_agency
      agency = ask('Agency (ADW): ', String) do |q|
        q.validate = /^(|.{3,5})$/
        q.responses[:not_valid] = "Invalid agency code. Must be between 3-5 characters."
        q.whitespace = :strip
      end
      agency = "ADW" if agency.blank?
      agency
    end
      
    extend Forwardable
    def_delegators :terminal, :agree, :ask, :choose, :say
  
    def terminal
      @terminal ||= HighLine.new
    end
  
    def output
      terminal.instance_variable_get("@output")
    end
  
    def wrap(string)
      string = terminal.send(:wrap, string) unless terminal.wrap_at.nil?
      string
    end
  
    def print(string)
      output.print(wrap(string))
      output.flush
    end
  
    def puts(string = "\n")
      say string
    end
  
    def announce(string)
      puts "\n#{string}"
    end
            
    def feedback(process, &block)
      print "#{process}..."
      if yield
        puts "OK"
        true
      else
        puts "FAILED"
        false
      end
    rescue Exception => e
      puts "FAILED"
      raise e
    end
      
    def step
      yield if block_given?
      print '.'
    end
      
  end
end