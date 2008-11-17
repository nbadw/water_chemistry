require File.join( File.dirname(__FILE__), 'aggregators', 'water_chemistry_sampling_aggregator' )

module Reports
  class WaterChemistrySampling < Ruport::Controller    
    stage :header, :parameter_tables, :qualifier_legend, :footer
  
    def setup      
      self.data ||= Reports::Aggregators::WaterChemistrySamplingAggregator.new(options)
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
        current_aquatic_activity_event = nil
        data.samples.each do |sample|                        
          @sample = sample
          if current_aquatic_activity_event != sample.aquatic_activity_event
            @aquatic_activity_event = current_aquatic_activity_event = sample.aquatic_activity_event            
            render_erb(:site_details)
          end
          @parameter_table = data.parameter_table(sample)
          render_erb(:sample_details)
          render_erb(:parameter_table)        
        end
      end
      
      build(:qualifier_legend) { render_erb(:qualifier_legend) }
      
      build(:footer) { render_erb(:footer) }
      
      def render_erb(template)
        output << erb("#{RAILS_ROOT}/app/reports/views/water_chemistry_sampling/#{template}.html.erb")
      end
    end
    
    
  end
end
