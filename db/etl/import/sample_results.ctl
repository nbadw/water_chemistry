# ETL Control file
source_columns = [:aquaticactivityid, :tempaquaticactivityid, :doe_program, :doe_projectno, 
    :doe_stationno, :doe_labno, :doe_fieldno, :secchidepth_m, :sampledepth_m, 
    :watertemp_c, :do, :toxic_unit, :l_hard, :hard, :no3, :l_al_x, :al_x, :l_al_xgf, 
    :al_xgf, :l_alk_g, :alk_g, :l_alk_p, :alk_p, :l_alk_t, :alk_t, :l_as_xgf, :as_xgf, 
    :l_ba_x, :ba_x, :l_b_x, :b_x, :l_br, :br, :l_ca_d, :ca_d, :l_cd_xgf, :cd_xgf, 
    :l_chl_a, :chl_a, :l_cl, :cl, :l_cl_ic, :cl_ic, :l_clra, :clra, :l_co_x, :co_x, 
    :l_cond, :cond, :cond2, :l_cr_x, :cr_x, :l_cr_xgf, :cr_xgf, :l_cu_x, :cu_x, 
    :l_cu_xgf, :cu_xgf, :l_doc, :doc, :l_f, :f, :l_fe_x, :fe_x, :l_hg_t, :hg_t, 
    :l_k, :k, :l_mg_d, :mg_d, :l_mn_x, :mn_x, :l_na, :na, :l_nh3t, :nh3t, :l_ni_x,
    :ni_x, :l_no2d, :no2d, :l_nox, :nox, :l_pb_xgf, :pb_xgf, :l_ph, :ph, :l_ph_gal, 
    :ph_gal, :l_sb_xgf, :sb_xgf, :l_se_xgf, :se_xgf, :silica, :l_so4, :so4, :l_so4_ic, 
    :so4_ic, :l_ss, :ss, :l_tds, :tds, :l_tkn, :tkn, :l_tl_xgf, :tl_xgf, :l_toc, 
    :toc, :l_tp_l, :tp_l, :l_turb, :turb, :l_zn_x, :zn_x, :l_zn_xgf, :zn_xgf, 
    :l_o_phos, :o_phos, :bicarb, :carb, :sat_ph, :sat_ndx]
destination_columns = [:id, :sample_id, :parameter_id, :value, :qualifier, :created_at, :updated_at]
outfile = "output/sample_results.csv"

source :in, { 
  :database => "dataWarehouse",
  :target => :aquatic_data_warehouse, 
  :table => "tblWaterChemistryAnalysis"
},  source_columns

destination :out, { 
  :file => outfile
}, { 
  :order => destination_columns,
  :virtual => { 
    :id => :surrogate_key,
    :created_at => Time.now,
    :updated_at => Time.now
  }
} 

after_read :surrogate_key, {
  :target => RAILS_ENV.to_sym, 
  :table => "tblSample",
  :column => :sampleid,
  :destination => :sample_id
}

after_read do |row| 
    rows = []
    ignored_columns = [:sampledepth_m, :aquaticactivityid, :tempaquaticactivityid, :doe_program, :doe_projectno, :doe_stationno, :doe_labno, :doe_fieldno]

    row.each do |column, value| 
        next if ignored_columns.include?(column) || column.to_s.match(/^l_/) # ignored or qualifier column?
        next if value.nil? || value == '0.0' || value == '999999.0'          # blank or flagged value?
        
        qualifier = row["l_#{column}".to_sym]
        new_row = { :sample_id => row[:sample_id], :parameter_id => column.to_s, :value => value, :qualifier => qualifier }
        rows << new_row
    end

    rows
end

transform :parameter_id, :decode, :decode_table_path => 'decode/parameter_table.txt', :default_value => ''

before_write :require_non_blank, :fields => [:parameter_id]

pre_process :truncate, {
  :target => RAILS_ENV.to_sym, 
  :table => "sample_results"
}

post_process :bulk_import, { 
  :file => outfile, 
  :columns => destination_columns, 
  :field_separator => ",", 
  :target => RAILS_ENV.to_sym, 
  :table => "sample_results"
}