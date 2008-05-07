class ActivityEvent < ActiveRecord::Base
  belongs_to :activity
  belongs_to :aquatic_site  
end
