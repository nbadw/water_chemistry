require File.dirname(__FILE__) + '/../../test_helper'

class InstrumentTest < ActiveSupport::TestCase
  should_use_table 'cdInstrument'
  should_use_primary_key 'InstrumentCd'
  
  should_have_db_column "Instrument", :type => :string, :limit => 50
  should_have_db_column "Instrument_Category", :type => :string, :limit => 50
  
  should_have_and_belong_to_many :measurements
end
