class TblSample < ActiveRecord::Base
  set_table_name  'tblSample'
  set_primary_key 'sampleid'
  acts_as_importable 
end
