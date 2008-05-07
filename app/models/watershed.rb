class Watershed < ActiveRecord::Base
  validates_presence_of   :drainage_code
  validates_format_of     :drainage_code, :with => /^\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}$/
  validates_uniqueness_of :drainage_code
end
