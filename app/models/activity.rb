class Activity < ActiveRecord::Base  
  has_many :aquatic_site_usages, :foreign_key => 'aquatic_activity_code'
  has_many :aquatic_sites, :through => :aquatic_site_usages
  
  validates_presence_of   :name, :category
  validates_uniqueness_of :name  
  
  def self.group_by_category(*args)
    options = args.extract_options!
    @activities = Activity.find(args.first, options)
    @activities.inject(Hash.new) do |hash, a|
      hash[a.category] = (hash[a.category] || []) << a
      hash
    end
  end
  
  def self.import_from_datawarehouse(attributes)
    record = Activity.new
    record.id = attributes['aquaticactivitycd']
    record.name = attributes['aquaticactivity']
    record.category = attributes['aquaticactivitycategory']
    record.duration = attributes['duration']
    record.save(false)
  end
end
