class Activity < ActiveRecord::Base
  acts_as_paranoid
  acts_as_versioned
  #acts_as_draftable
  
  belongs_to :agency
  has_many   :tasks
end
