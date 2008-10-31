module Reports
  class WaterChemistrySampling < Ruport::Controller    
    stage :header, :parameter_tables, :qualifier_legend, :footer
  
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
        current_aquatic_activity_event = nil
        data.samples.each do |sample|                        
          @sample = sample
          if current_aquatic_activity_event != sample.aquatic_activity_event
            @aquatic_activity_event = current_aquatic_activity_event = sample.aquatic_activity_event            
            render_erb(:activity_details)
          end
          @parameter_table = data.parameter_table(sample)
          render_erb(:parameter_table)        
        end
      end
      
      build(:qualifier_legend) { render_erb(:qualifier_legend) }
      
      build(:footer) { render_erb(:footer) }
      
      def render_erb(template)
        output << erb("#{RAILS_ROOT}/app/reports/views/water_chemistry_sampling/#{template}.html.erb")
      end
    end
    
    class SamplesAggregator
      attr_reader :agency
      
      def initialize(options={})  
        @agency = options[:agency]
        if (report_on = options[:report_on]).is_a?(Hash)
          @aquatic_sites = [*report_on[:aquatic_site]]
          @aquatic_activity_events = [*report_on[:aquatic_activity_event]] if report_on[:aquatic_activity_event]
        else
         @aquatic_sites = [*report_on]
        end
      end
      
      def aquatic_sites
        @aquatic_sites ||= []
      end
      
      def aquatic_activity_events
        @aquatic_activity_events ||= aquatic_sites.collect{ |site| site.aquatic_activity_events }.flatten
      end
      
      def samples
        @samples ||= aquatic_activity_events.collect { |event| event.samples }.flatten
      end
      
      def qualifiers
        @qualifiers ||= Qualifier.all
      end
      
      def parameter_table(sample)
        build_parameter_table(sample)
      end
      
      def to_csv            
        return '' if samples.empty?  
        
        # create merged parameter table
        table = nil
        samples.each do |sample|
          parameter_table = build_parameter_table(sample)     
          parameter_table.add_column('ADW Sample ID', :position => 0, :default => sample.id)
          table = (table ? table + parameter_table : parameter_table)
        end
        table = table.pivot('Parameter', :group_by => 'ADW Sample ID', :values => 'Measurement')
        
        # add extra columns
        table.add_column('Aquatic Site ID',   :position => 1)
        table.add_column('Waterbody ID',      :position => 2)
        table.add_column('Waterbody Name',    :position => 3)
        table.add_column('Drainage Code',     :position => 4)
        table.add_column('Site Description',  :position => 5)
        table.add_column('Date Sampled',      :position => 6)    
        table.add_column('Sampled By',        :position => 7)
        table.add_column('Agency Sample No.', :position => 8)
        table.add_column('Analyzed By',       :position => 9)
        table.add_column('Lab No.',           :position => 10)
        
        # populate extra columns
        table.data.each do |row|
          sample = [*samples].find { |sample| sample.id == row["ADW Sample ID"] }
          aquatic_activity_event = sample.aquatic_activity_event
          agency = aquatic_activity_event.agency
          aquatic_site = aquatic_activity_event.aquatic_site
          waterbody = aquatic_site.waterbody
          
          row['Aquatic Site ID']   = aquatic_site.id
          row['Waterbody ID']      = waterbody.id
          row['Waterbody Name']    = waterbody.water_body_name
          row['Drainage Code']     = waterbody.drainage_cd
          row['Site Description']  = aquatic_site.aquatic_site_desc
          row['Date Sampled']      = aquatic_activity_event.start_date   
          row['Sampled By']        = agency.id
          row['Agency Sample No.'] = sample.agency_sample_no
          row['Analyzed By']       = sample.analyzed_by
          row['Lab No.']           = sample.lab_no
        end
        
        table.to_csv
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
