require File.dirname(__FILE__) + '/../test_helper'
require 'hpricot'

class RecordedChemicalsControllerTest < ActionController::TestCase
  context "logged in" do
    setup { login }
    
    context "when rendering the 'list' action" do      
      should "show an empty table if there are no records" do
        get :list 
        assert_response :success
        assert_template 'list'
        
        doc = Hpricot(@response.body)
        assert_match(/No Entries/, (doc/'#recorded_chemicals-empty-message').first.inner_text)
      end
      
      should "show a table of parameters" do
        chemical = Measurement.spawn
        chemical.parameter = 'Test'
        chemical.parameter_cd = 'T'
        recorded_chemical = WaterMeasurement.spawn
        recorded_chemical.stubs(:chemical).returns(chemical)        
        recorded_chemical.stubs(:measurement).returns(5.5)
        WaterMeasurement.expects(:find).returns([recorded_chemical])
        
        get :list 
        assert_response :success
        assert_template 'list'
        
        doc = Hpricot(@response.body)
        assert_match(/Parameter Name/, (doc/'#recorded_chemicals-parameter_name-column').first.inner_text)
        assert_match(/Parameter Code/, (doc/'#recorded_chemicals-parameter_code-column').first.inner_text)
        assert_match(/Value/, (doc/'#recorded_chemicals-measurement-column').first.inner_text)
        assert_match(/Qualifier/, (doc/'#recorded_chemicals-qualifier_cd-column').first.inner_text)
        
        rows = doc/'tr.record'        
        assert_equal 1, rows.size
        assert_match(/Test/, (rows/'td')[0].inner_text)        
        assert_match(/T/, (rows/'td')[1].inner_text) 
        assert_match(/5.5/, (rows/'td')[2].inner_text) 
      end
    end
        
    context "when rendering the 'new' action" do
      setup do
        chemicals = [
          Measurement.spawn(:parameter => 'parameter_1'),
          Measurement.spawn(:parameter => 'parameter_1'),
          Measurement.spawn(:parameter => 'parameter_1')
        ]
        chemicals.each_with_index { |obs, i| obs.id = i + 1 }
        Measurement.expects(:chemicals).returns(chemicals)
        WaterMeasurement.expects(:recorded_chemicals).with('1').returns([])

        # stub the sample found in find_current_aquatic_activity
        sample = stub(:aquatic_activity_event => nil)
        Sample.stubs(:find).returns(sample)

        with_constraints :sample => '1'
        get :new, :eid => eid
        
        assert_response :success
        assert_template 'create_form'
      end

      should "render a drop-down of chemicals to choose from" do
        doc = Hpricot(@response.body)
      end      
    end    
    
#    context "when 'create' action is called" do
#      should "create a recorded observation recorded with an observable value" do        
#        #with_constraints :aquatic_activity_event_id => '2'
#        post :create 
#      end
#    end
  end
end
