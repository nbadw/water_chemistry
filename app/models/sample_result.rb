class SampleResult < ActiveRecord::Base
  belongs_to :parameter
  belongs_to :sample, :class_name => 'TblSample', :foreign_key => 'sample_id'
  
  validates_presence_of :parameter, :sample, :value
  validates_uniqueness_of :parameter_id, :scope => :sample_id
end
