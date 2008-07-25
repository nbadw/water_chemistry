class Location
 # include ActiveRecord::Validations
  
#  validates_presence_of  :currency
#  validates_inclusion_of :currency, :in => ['USD', 'EUR'], :if => :currency?
#  validates_presence_of     :balance
#  validates_numericality_of :balance, :if => :balance?
  
  attr_reader :latitude, :longitude, :coordinate_system_id
  
  def initialize(latitude, longitude, coordinate_system_id)
    @latitude, @longitude, @coordinate_system_id = latitude, longitude, coordinate_system_id    
    #@errors = ActiveRecord::Errors.new self
  end
  
  # methods below needed to fake out ActiveRecord::Base validations
#  def new_record?
#    true
#  end
#  
#  def latitude?
#    !@latitude.blank?
#  end
#  
#  def longitude?
#    !@longitude.blank?
#  end
#  
#  def coordinate_system_id?
#    !@coordinate_system_id.blank?
#  end
#  
#  def self.human_attribute_name(attr)
#    attr.humanize
#  end
#  
#  def latitude_before_type_cast
#    @latitude
#  end  
#  
#  def longitude_before_type_cast
#    @longitude
#  end
#  
#  def coordinate_system_id_before_type_cast
#    @coordinate_system_id
#  end
end
