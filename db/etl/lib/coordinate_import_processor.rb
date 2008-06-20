require 'geo_ruby'

module ETL
  module Processor
    class CoordinateImportProcessor < ETL::Processor::Processor
      include GeoRuby::Shp4r
      
      attr_reader :shape_file, :shape_id, :target, :table, :id_column, :lat_column, :lng_column, :default_lat, :default_lng
       
      # Initialize the processor.
      #
      # Configuration options:
      # * <tt>:shape_file</tt>: The shape file to load data from
      # * <tt>:shape_id</tt>: The id to read from the shape file (defaults to id)
      # * <tt>:target</tt>: The target database
      # * <tt>:table</tt>: The table name
      # * <tt>:id_column</tt>: The id column (defaults to id)
      # * <tt>:lat_column</tt>: The latitude column (defaults to latitude)
      # * <tt>:lng_column</tt>: The longitude column (defaults to longitude)
      # * <tt>:default_lat</tt>: The default latitude value (defaults to null)
      # * <tt>:default_lng</tt>: The default longitude value (defaults to null)
      def initialize(control, configuration)
        super
        @shape_file = File.join(File.dirname(control.file), configuration[:shape_file])
        @shape_id = configuration[:shape_id] || :id
        @target = configuration[:target]
        @table = configuration[:table]
        @id_column = configuration[:id_column] || :id
        @lat_column = configuration[:lat_column] || :latitude
        @lng_column = configuration[:lng_column] || :longitude
        
        raise ControlError, "Shape file must be specified" unless @shape_file
        raise ControlError, "Target must be specified" unless @target
        raise ControlError, "Table must be specified" unless @table
      end
      
      # Execute the processor
      def process   
        conn = ETL::Engine.connection(target)
        conn.transaction do
          coordinates.each do |coordinate|
            next unless coordinate[id_column]            
            q = "UPDATE #{table_name} SET #{lat_column} = #{coordinate[lat_column]}, #{lng_column} = #{coordinate[lng_column]} WHERE #{id_column} = #{coordinate[id_column]}"
            conn.update(q)
          end
        end
        
      end
      
      def coordinates
        coordinates = []
        ShpFile.open(shape_file) do |shpfile|
          shpfile.each do |shape| 
            if(shape.geometry.text_geometry_type == 'POINT')
              coordinate = {}
              shpfile.fields.each { |field| coordinate[id_column] = shape.data[field.name] if field.name.downcase == shape_id.to_s.downcase } 
              coordinate[lat_column] = shape.geometry.lat 
              coordinate[lng_column] = shape.geometry.lon
              coordinates << coordinate
            end             
          end
        end
        coordinates
      end
      
      def table_name
        ETL::Engine.table(table, ETL::Engine.connection(target))
      end
      
    end
  end
end
