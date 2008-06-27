src_columns = [:waterbodyid, :cgndb_key, :cgndb_key_alt, :drainagecd, :waterbodytypecd,
  :waterbodyname, :waterbodyname_abrev, :waterbodyname_alt, :waterbodycomplexid,
  :surveyed_ind, :flowsintowaterbodyid, :flowsintowaterbodyname, :flowintodrainagecd,
  :dateentered, :datemodified]
dst_columns = [:id, :name, :abbreviated_name, :alt_name, :drainage_code, :waterbody_type,
  :waterbody_complex_id, :surveyed, :flows_into_waterbody_id, :imported_at, :exported_at, 
  :created_at, :updated_at]
outfile = "output/waterbodies.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblWaterBody"
}, src_columns

rename :waterbodyid, :id
rename :waterbodyname, :name
rename :waterbodyname_abrev, :abbreviated_name
rename :waterbodyname_alt, :alt_name
rename :drainagecd, :drainage_code
rename :waterbodytypecd, :waterbody_type
rename :waterbodycomplexid, :waterbody_complex_id
rename :surveyed_ind, :surveyed
rename :flowsintowaterbodyname, :flows_into_waterbody_id
rename :dateentered, :created_at
rename :datemodified, :updated_at

transform(:surveyed) { |name, val, row| val.to_s.upcase == 'Y' ? 1 : 0 }
transform(:created_at) { |name, val, row| DateTime.now if val.nil? }
transform(:updated_at) { |name, val, row| DateTime.now if val.nil? }

before_write :check_exist, :target => RAILS_ENV, :table => "waterbodies", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => { 
    :imported_at => DateTime.now
  }   
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "waterbodies"
}