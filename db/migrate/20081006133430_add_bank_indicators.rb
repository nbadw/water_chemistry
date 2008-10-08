class AddBankIndicators < ActiveRecord::Migration
  class Measurement < ActiveRecord::Base
    set_table_name  'cdOandM'
    set_primary_key 'OandMCd'
  end
  
  def self.up
    modify_measurements do |measurement|      
      measurement.write_attribute('BankInd', true)
      measurement.save!
    end
  end

  def self.down
    modify_measurements do |measurement|
      measurement.write_attribute('BankInd', false)
      measurement.save!
    end
  end
  
  private 
  def self.modify_measurements
    meas_ids = [74, 75]
    Measurement.find(meas_ids).each do |measurement|
      yield measurement
    end
  end
end
