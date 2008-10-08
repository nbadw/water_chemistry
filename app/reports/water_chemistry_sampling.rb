module Reports
  class WaterChemistrySampling < Ruport::Controller    
    stage :header, :activity_details, :parameter_table, :footer
  
    def setup      
      self.data ||= SampleResultsAggregator.new(options)
    end
    
    class CSV < Ruport::Formatter::CSV
      renders :csv, :for => WaterChemistrySampling  

      build :parameter_table do
        output << data.rows.to_csv
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
      
      build :activity_details do
        render_erb(:activity_details)
      end
      
      build :parameter_table do
        render_erb(:parameter_table)
      end
      
      build(:footer) { render_erb(:footer) }
      
      def render_erb(stage_name)
        output << erb("#{RAILS_ROOT}/app/reports/views/water_chemistry_sampling/#{stage_name}.html.erb")
      end
    end
    
    class SampleResultsAggregator
      attr_reader :aquatic_activity_event, :aquatic_site, :waterbody, :agency
      
      def initialize(options={})        
        @aquatic_activity_event = options[:aquatic_activity_event]
        @aquatic_site = options[:aquatic_site]
        @waterbody = @aquatic_site.waterbody
        @agency = options[:agency]
      end
      
      def rows
        samples = Sample.for_aquatic_activity_event(aquatic_activity_event.id)
        table = Table([:parameter, :code, :measurement, :qualifier, :comment]) do |t|      
          samples.each do |sample|
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
        end
        table.rename_columns { |c| c.to_s.titleize }
        table
      end
    end
  end
end
