class Watershed < ActiveRecord::Base
  has_many :waterbodies, :foreign_key => 'drainage_code'
  
  validates_presence_of   :drainage_code
  validates_format_of     :drainage_code, :with => /^\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}$/
  validates_uniqueness_of :drainage_code
  
  def self.import_from_datawarehouse(attributes)
    watershed = Watershed.new
    watershed.id = attributes['drainagecd']
    watershed.name = attributes['unitname']
    watershed.unit_type = attributes['unittype']
    watershed.border = attributes['borderind'] || false
    watershed.stream_order = attributes['streamorder']
    watershed.area_ha = attributes['area_ha']
    watershed.area_percent = attributes['area_percent']
    watershed.drains_into = attributes['drainsinto']
    6.times do |i|
      watershed.send("level#{i+1}_no=".to_sym, attributes["level#{i+1}no"])
      watershed.send("level#{i+1}_name=".to_sym, attributes["level#{i+1}name"])
    end
    watershed.save(false)
  end
end
