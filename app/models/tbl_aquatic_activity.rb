class TblAquaticActivity < ActiveRecord::Base
  set_table_name  'tblAquaticActivity'
  set_primary_key 'aquaticactivityid'
  
  alias_attribute :weather_conditions, :weatherconditions
  alias_attribute :rain_fall_in_last_24_hours, :rainfall_last24
  
  belongs_to :aquatic_activity_code, :class_name => 'CdAquaticActivity', :foreign_key => 'aquaticactivitycd' 
  belongs_to :aquatic_site, :class_name => 'TblAquaticSite', :foreign_key => 'aquaticsiteid'
  belongs_to :agency, :class_name => 'CdAgency', :foreign_key => 'agencycd'
  belongs_to :agency2, :class_name => 'CdAgency', :foreign_key => 'agency2cd'
  belongs_to :aquatic_activity_method_code, :class_name => 'CdAquaticActivityMethod', :foreign_key => 'aquaticmethodcd'
  
  validates_inclusion_of :rainfall_last24, :in => %w(None Light Heavy)
  
  acts_as_importable
  
  def start_date
    date_str = "#{self.aquaticactivitystartdate} #{self.aquaticactivitystarttime}".strip
    date_str = "#{date_str}/01/01" if date_str.match(/^\d{4}\/?$/) # some times we only get the year back
    start_date = nil
    begin
      start_date = DateTime.parse date_str unless date_str.empty?
    rescue
      logger.error "couldn't parse start date #{date_str} for #{self.inspect}" if logger.error?
    end
    start_date
  end
  
  def end_date
    date_str = "#{self.aquaticactivityenddate} #{self.aquaticactivityendtime}".strip
    date_str = "#{date_str}/01/01" if date_str.match(/^\d{4}\/?$/) # some times we only get the year back
    end_date = nil
    begin
      end_date = DateTime.parse date_str unless date_str.empty?
    rescue
      logger.error "couldn't parse end date #{date_str} for #{self.inspect}" if logger.error?
    end
    end_date
  end
end
