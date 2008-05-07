class Activity < ActiveRecord::Base  
  has_many :activity_events
  has_many :sites, :through => :activity_events
  
  validates_presence_of   :name, :category
  validates_uniqueness_of :name  
  
  class << self 
    def group_by_category(*args)
      options = args.extract_options!
      @activities = Activity.find(args.first, options)
      @activities.inject(Hash.new) do |hash, a|
        hash[a.category] = (hash[a.category] || []) << a
        hash
      end
    end
  end
end
