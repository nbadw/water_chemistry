module Reports
  class WaterChemistrySampling < Ruport::Controller
    stage :parameter_table, :qualifier_legend
  
    def setup      
      aggregator_options = {
        :aquatic_site_id => options[:aquatic_site_id],
        :aquatic_activity_event_id => options[:aquatic_activity_event_id],
        :aquatic_site_ids => options[:aquatic_site_ids]
      }
      self.data ||= SampleResultsAggregator.new(aggregator_options)
    end
    
    class CSV < Ruport::Formatter::CSV
      renders :csv, :for => WaterChemistrySampling  

      build :parameter_table do
        output << data.rows.to_csv
      end
    end
  
    class HTML < Ruport::Formatter::HTML
      renders :html, :for => WaterChemistrySampling
      
      build :parameter_table do
        #output << erb(RAILS_ROOT + "/app/reports/views/#{self.class.underscore}.html.erb")
        output << data.rows.to_html
      end
    end
    
    class SampleResultsAggregator
      attr_reader :aquatic_activity_event_id
      
      def initialize(options={})        
        @aquatic_activity_event_id = options[:aquatic_activity_event_id]
      end
      
      def rows
        samples = Sample.for_aquatic_activity_event(aquatic_activity_event_id)
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
