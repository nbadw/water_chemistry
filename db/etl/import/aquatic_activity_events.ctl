# ETL Control file
model = AquaticActivityEvent
table = model.table_name.to_s
outfile = "output/#{table}.csv"
columns = model.columns.collect { |column| column.name.to_sym }

source :in, { 
  :type => :access,
  :mdb => "C:/Documents and Settings/nbdata/Desktop/data entry/WaterChemTables.mdb", 
  :table => table
}, columns

transform(:agency_id) { |name, value, row| row[name] = row[:agencycd] }
transform :agency_id,  :decode, :decode_table_path => 'decode/agency_table.txt', :default_value => ''

transform(:agency2_id) { |name, value, row| row[name] = row[:agency2cd] }
transform :agency2_id, :decode, :decode_table_path => 'decode/agency_table.txt', :default_value => ''

before_write do |row|     
    row[:primaryactivityind] = row[:primaryactivityind] == 'true' ? 1 : 0
    row[:created_at] = DateTime.parse(row[:dateentered]) rescue DateTime.now
    if row[:incorporatedind] == 'true'      
      row[:exported_at] = DateTime.parse(row[:datetransferred]) rescue DateTime.now
    end
    row[:incorporatedind] = row[:incorporatedind] == 'true' ? 1 : 0
    row[:start_date] = DateTime.parse("#{row[:aquaticactivitystartdate]} #{row[:aquaticactivitystarttime]}".strip) rescue ''
    row[:end_date] = DateTime.parse("#{row[:aquaticactivityenddate]} #{row[:aquaticactivityendtime]}".strip) rescue ''
    row
end

before_write :check_exist, :target => RAILS_ENV, :table => table, :columns => [model.primary_key.to_sym]

destination :out, { 
  :file => outfile
}, { 
  :order => columns,
  :virtual => { 
    :created_at => Time.now,
    :updated_at => Time.now,
    :imported_at => Time.now
  }
}  

post_process :bulk_import, { 
  :file => outfile, 
  :columns => columns, 
  :field_separator => ",", 
  :target => RAILS_ENV, 
  :table => table
}
