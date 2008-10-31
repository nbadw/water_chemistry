require File.dirname(__FILE__) + '/../../test_helper'

class WaterChemistrySamplingReportTest < ActiveSupport::TestCase
  context "for only one aquatic site and event" do
    setup do
      @aquatic_site = AquaticSite.generate!      
      @ignored_aquatic_activity_event = AquaticActivityEvent.generate!(:aquatic_site => @aquatic_site)
      @aquatic_activity_event = AquaticActivityEvent.generate!(:aquatic_site => @aquatic_site)
      @samples = [
        Sample.generate!(:aquatic_activity_event => @aquatic_activity_event),
        Sample.generate!(:aquatic_activity_event => @aquatic_activity_event)
      ]
    
      options = {
        :report_on => {
          :aquatic_site => @aquatic_site,
          :aquatic_activity_event => @aquatic_activity_event
        }
      }
      @aggregator = Reports::WaterChemistrySampling::SamplesAggregator.new(options)
    end
    
    should "be able to render to csv" do
      Reports::WaterChemistrySampling.render_csv(:data => @aggregator) 
    end
    
    should "be able to render to html" do 
      Reports::WaterChemistrySampling.render_html(:data => @aggregator)
    end
    
    should "report on only one aquatic site" do
      assert_equal 1, @aggregator.aquatic_sites.length
      assert_equal @aquatic_site, @aggregator.aquatic_sites.first
    end
    
    should "report on only one aquatic activity event" do
      assert_equal 1, @aggregator.aquatic_activity_events.length
      assert @aggregator.aquatic_activity_events.include?(@aquatic_activity_event)
      assert !@aggregator.aquatic_activity_events.include?(@ignored_aquatic_activity_event)
    end
    
    should "report on all samples" do
      assert_equal 2, @aggregator.samples.length
    end
  end
  
  context "for one aquatic site and many events" do
    setup do
      @aquatic_site = AquaticSite.generate!      
      @aquatic_activity_event_1 = AquaticActivityEvent.generate!(:aquatic_site => @aquatic_site)
      @aquatic_activity_event_2 = AquaticActivityEvent.generate!(:aquatic_site => @aquatic_site)
      @samples = []
      2.times { @samples << Sample.generate!(:aquatic_activity_event => @aquatic_activity_event_1) }
      3.times { @samples << Sample.generate!(:aquatic_activity_event => @aquatic_activity_event_2) } 
      @aggregator = Reports::WaterChemistrySampling::SamplesAggregator.new(:report_on => @aquatic_site)
    end
    
    should "be able to render to csv" do
      Reports::WaterChemistrySampling.render_csv(:data => @aggregator)
    end
    
    should "be able to render to html" do 
      Reports::WaterChemistrySampling.render_html(:data => @aggregator)
    end
    
    should "report on only one aquatic site" do
      assert_equal 1, @aggregator.aquatic_sites.length
      assert_equal @aquatic_site, @aggregator.aquatic_sites.first
    end
    
    should "report on all aquatic activity events" do
      assert_equal 2, @aggregator.aquatic_activity_events.length
      assert @aggregator.aquatic_activity_events.include?(@aquatic_activity_event_1)
      assert @aggregator.aquatic_activity_events.include?(@aquatic_activity_event_2)
    end
    
    should "report on all samples" do
      assert_equal 5, @aggregator.samples.length
    end
  end
  
  context "for many aquatic sites" do
    setup do
      @aquatic_sites = []
      2.times { @aquatic_sites << AquaticSite.generate! }      
      @aquatic_activity_events = []
      3.times { @aquatic_activity_events << AquaticActivityEvent.generate!(:aquatic_site => random(@aquatic_sites)) }
      @samples = []
      5.times { @samples << Sample.generate!(:aquatic_activity_event => random(@aquatic_activity_events)) }
      water_meas = WaterMeasurement.generate!(
        :sample => @samples.first, 
        :measurement => 37,
        :o_and_m => OandM.spawn(:oand_m_parameter => 'Test', :oand_m_parameter_cd => 'TST')
      )
      
      @aggregator = Reports::WaterChemistrySampling::SamplesAggregator.new(:report_on => @aquatic_sites)
    end
    
    should "be able to render to csv" do
      Reports::WaterChemistrySampling.render_csv(:data => @aggregator)      
    end
    
    should "be able to render to html" do 
      Reports::WaterChemistrySampling.render_html(:data => @aggregator)
    end
    
    should "report on all aquatic sites" do
      assert_equal 2, @aggregator.aquatic_sites.length
    end
    
    should "report on all aquatic activity events" do
      assert_equal 3, @aggregator.aquatic_activity_events.length
    end
    
    should "report on all samples" do
      assert_equal 5, @aggregator.samples.length
    end
  end
  
  private
  def random(array)
    array[rand(array.length)]    
  end
end
