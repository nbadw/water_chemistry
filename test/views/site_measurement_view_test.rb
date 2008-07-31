require File.dirname(__FILE__) + '/../view_test_helper'

class SiteMeasurementViewTest < Test::Rails::ViewTestCase  
  context "using partial for instrument form column" do
    should_eventually "be hidden if no measurement has been selected" do
      record = SiteMeasurement.new
      assert_nil record.measurement
      assigns[:record] = record
      
      render :template => 'site_measurement/instrument_form_column'
      
      assert_select_tag :record, :instrument
    end
  end
end
