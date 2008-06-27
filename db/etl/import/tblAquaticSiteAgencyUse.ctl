src_columns = [:aquaticsiteuseid, :aquaticsiteid, :aquaticactivitycd, :aquaticsitetype,
  :agencycd, :agencysiteid, :startyear, :endyear, :yearsactive, :incorporatedind]
dst_columns = [:id, :aquatic_site_id, :aquatic_activity_id, :aquatic_site_type, :agency_id,
  :agency_site_id, :start_year, :end_year, :years_active, :imported_at, :exported_at, 
  :created_at, :updated_at]
outfile = "output/aquatic_site_usages.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblAquaticSiteAgencyUse"
}, src_columns

rename :aquaticsiteuseid, :id
rename :aquaticsiteid, :aquatic_site_id
rename :aquaticactivitycd, :aquatic_activity_id
rename :aquaticsitetype, :aquatic_site_type
rename :agencycd, :agency_id
rename :agencysiteid, :agency_site_id
rename :startyear, :start_year
rename :endyear, :end_year
rename :yearsactive, :years_active

transform :agency_id, :decode, :decode_table_path => 'decode/agency_table.txt', :default_value => ''
transform(:exported_at) { |name, val, row| DateTime.now if row[:incorporatedind] == 'true' }

before_write :check_exist, :target => RAILS_ENV, :table => "aquatic_site_usages", :columns => [:id]

destination :out, { 
  :file => outfile
}, { 
  :order => dst_columns,
  :virtual => {
    :created_at  => DateTime.now,
    :updated_at  => DateTime.now,
    :imported_at => DateTime.now
  }  
} 

post_process :bulk_import, { 
  :file => outfile, 
  :columns => dst_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => "aquatic_site_usages"
}