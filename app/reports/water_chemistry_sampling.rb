module Reports
  class WaterChemistrySampling < Ruport::Controller    
    stage :header, :parameter_tables, :footer
  
    def setup      
      self.data ||= SamplesAggregator.new(options)
    end
    
    class CSV < Ruport::Formatter::CSV
      renders :csv, :for => WaterChemistrySampling  

      build :parameter_tables do
        output << data.to_csv
      end
    end
  
    class HTML < Ruport::Formatter::HTML
      renders :html, :for => WaterChemistrySampling
      
      def layout
        output << '<div id="water-chemistry-report">'
        yield
        output << '</div>'
      end  
      
      build(:header) { render_erb(:header) }
            
      build :parameter_tables do
        data.each do       
          render_erb(:activity_details)
          render_erb(:parameter_table)        
        end
      end
      
      build(:footer) { render_erb(:footer) }
      
      def render_erb(template)
        output << erb("#{RAILS_ROOT}/app/reports/views/water_chemistry_sampling/#{template}.html.erb")
      end
    end
    
    class SamplesAggregator
      attr_reader :aquatic_activity_event, :aquatic_site, :waterbody, :agency
      
      def initialize(options={})        
        @aquatic_activity_event = options[:aquatic_activity_event]
        @aquatic_site = options[:aquatic_site]
        @waterbody = @aquatic_site.waterbody
        @agency = options[:agency]
        @samples = nil
        @current_sample = nil
        @parameter_table = nil
      end
      
      def each
        samples.each do |sample|
          @current_sample = sample
          @parameter_table = build_parameter_table(@current_sample)
          yield
        end
      end
      
      def sample
        @current_sample
      end
      
      def parameter_table
        @parameter_table
      end
                
      def samples
        @samples ||= Sample.for_aquatic_activity_event(aquatic_activity_event.id)
      end
      
      def to_csv        
        tables = samples.collect do |sample| 
          table = build_parameter_table(sample)
          table.add_column('sample_id', :position => 0) do |r|
            sample.id
          end
        end
        
        full_table = nil
        tables.each { |t| full_table = full_table ? full_table + t : t }        
        full_table = full_table.pivot('Parameter', :group_by => 'sample_id', :values => 'Measurement')
        
        full_table.to_csv
      end
      
      private
      def build_parameter_table(sample)
        table = Table([:parameter, :code, :measurement, :qualifier, :comment]) do |t| 
          sample.sample_results.each do |sample| 
            row = {}
            row[:parameter] = sample.chemical.parameter
            row[:code] = sample.chemical.parameter_cd
            row[:measurement] = sample.measurement
            row[:qualifier] = sample.qualifier ? sample.qualifier.id : nil
            row[:comment] = sample.comment || nil
            t << row
          end
        end
        table.rename_columns { |c| c.to_s.titleize }
        table
      end
    end
  end
end
