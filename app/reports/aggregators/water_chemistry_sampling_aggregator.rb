module Reports
  module Aggregators
    class WaterChemistrySamplingAggregator
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

        # report headers
        h = {
          'ADW Sample ID'     => :adw_sample_id_report_label.l,
          'Aquatic Site ID'   => :aquatic_site_id_report_label.l,
          'Waterbody ID'      => :waterbody_id_report_label.l,
          'Waterbody Name'    => :waterbody_name_report_label.l,
          'Drainage Code'     => :drainage_code_report_label.l,
          'Site Description'  => :site_description_report_label.l,
          'Date Sampled'      => :date_sampled_report_label.l,
          'Sampled By'        => :sampled_by_report_label.l,
          'Agency Sample No.' => :agency_sample_no_report_label.l,
          'Analyzed By'       => :analyzed_by_report_label.l,
          'Lab No.'           => :lab_no_report_label.l
        }
        
        # create merged parameter table
        table = nil
        samples.each do |sample|
          parameter_table = build_parameter_table(sample)     
          parameter_table.add_column(h['ADW Sample ID'], :position => 0, :default => sample.id)
          table = (table ? table + parameter_table : parameter_table)
        end
        table = table.pivot(:parameter_report_label.l, :group_by => h['ADW Sample ID'], :values => :measurement_report_label.l)
        
        # add extra columns
        table.add_column(h['Aquatic Site ID'],   :position => 1)
        table.add_column(h['Waterbody ID'],      :position => 2)
        table.add_column(h['Waterbody Name'],    :position => 3)
        table.add_column(h['Drainage Code'],     :position => 4)
        table.add_column(h['Site Description'],  :position => 5)
        table.add_column(h['Date Sampled'],      :position => 6)
        table.add_column(h['Sampled By'],        :position => 7)
        table.add_column(h['Agency Sample No.'], :position => 8)
        table.add_column(h['Analyzed By'],       :position => 9)
        table.add_column(h['Lab No.'],           :position => 10)
        
        # populate extra columns
        table.data.each do |row|
          sample = [*samples].find { |sample| sample.id == row[h["ADW Sample ID"]] }
          aquatic_activity_event = sample.aquatic_activity_event
          agency = aquatic_activity_event.agency
          aquatic_site = aquatic_activity_event.aquatic_site
          waterbody = aquatic_site.waterbody
          
          row[h['Aquatic Site ID']]   = aquatic_site.id
          row[h['Waterbody ID']]      = waterbody.id
          row[h['Waterbody Name']]    = waterbody.water_body_name
          row[h['Drainage Code']]     = waterbody.drainage_cd
          row[h['Site Description']]  = aquatic_site.aquatic_site_desc
          row[h['Date Sampled']]      = aquatic_activity_event.start_date
          row[h['Sampled By']]        = agency.id
          row[h['Agency Sample No.']] = sample.agency_sample_no
          row[h['Analyzed By']]       = sample.analyzed_by
          row[h['Lab No.']]           = sample.lab_no
        end
        
        table.to_csv
      end      
      
      private
      def build_parameter_table(sample)
        # table headers
        h = {
          'parameter'       => :parameter_report_label.l,
          'measurement'     => :measurement_report_label.l,
          'unit_of_measure' => :unit_of_measure_report_label.l,
          'qualifier'       => :qualifier_report_label.l,
          'comment'         => :comment_report_label.l
        }

        table = Table([:parameter, :measurement, :unit_of_measure, :qualifier, :comment]) do |t| 
          sample.sample_results.each do |sample| 
            row = {}
            row[:parameter] = sample.chemical.parameter
            row[:parameter] += " (#{sample.chemical.parameter_cd})" unless sample.chemical.parameter_cd.to_s.empty?
            row[:measurement] = sample.measurement
            row[:unit_of_measure] = sample.unit_of_measure ? sample.unit_of_measure.abbrev : nil
            row[:qualifier] = sample.qualifier ? sample.qualifier.id : nil
            row[:comment] = sample.comment || nil
            t << row
          end
        end
        table.rename_columns { |c| h[c.to_s] }
        table
      end
    end
  end
end
