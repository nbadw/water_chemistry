require File.dirname(__FILE__) + '/../test_helper'
require 'hpricot'

class RecordedObservationsControllerTest < ActionController::TestCase
  context "logged in" do
    setup { login }
    
    context "when rendering the 'list' action" do
      should "render a table of observations" do
        get :list
      end
    end
        
    context "when rendering the 'new' action" do
      setup do
        observations = [
          Observation.spawn(:group => 'group_1', :name => 'obs_1' ),
          Observation.spawn(:group => 'group_1', :name => 'obs_2' ),
          Observation.spawn(:group => 'group_2', :name => 'obs_3' )
        ]
        observations.each_with_index { |obs, i| obs.id = i + 1 }
        Observation.expects(:all).returns(observations)

        get :new         
        
        assert_response :success
        assert_template 'create_form'
      end

      should_eventually "render a drop-down of observations to choose from and hidden fields for extra details" do
        doc = Hpricot(@response.body)
        optgroup_tags = doc/'#selected_observation'/'optgroup'
        assert_equal 2, optgroup_tags.size
        assert_equal 'group_1', optgroup_tags[0]['label']
        assert_equal 'group_2', optgroup_tags[1]['label']

        group_1_options = optgroup_tags[0]/'option'
        assert_equal 2, group_1_options.size
        assert_equal '1', group_1_options[0]['value']
        assert_equal 'obs_1', group_1_options[0].inner_text
        assert_equal '2', group_1_options[1]['value']
        assert_equal 'obs_2', group_1_options[1].inner_text

        group_2_options = optgroup_tags[1]/'option'
        assert_equal 1, group_2_options.size
        assert_equal '3', group_2_options[0]['value']
        assert_equal 'obs_3', group_2_options[0].inner_text 

        assert_match(/display:.?none/, (doc/'#value_observed').first['style'])
        assert_match(/display:.?none/, (doc/'#fish_passage_blocked').first['style'])
      end      
    end
    
    context "when handling an observation change event" do
      should "show the fish passage blocked form element when fish_passage_ind is true" do        
        Observation.expects(:find).with('1').returns(Observation.spawn(:fish_passage_ind => true))
        get :on_observation_change, :observation_id => '1' 
        assert_response :success
        assert 'text/javascript', @response.content_type
        assert_match(/Element\.show\("fish_passage_blocked"\);/, @response.body)
      end   

      should "hide the fish passage blocked form element when fish_passage_ind is false" do        
        Observation.expects(:find).with('1').returns(Observation.spawn(:fish_passage_ind => false))
        get :on_observation_change, :observation_id => '1' 
        assert_response :success
        assert 'text/javascript', @response.content_type
        assert_match(/Element\.hide\("fish_passage_blocked"\);/, @response.body)
      end    
      
      should "show the value observed form element" do
        Observation.expects(:find).with('1').returns(Observation.spawn)
        get :on_observation_change, :observation_id => '1' 
        assert_response :success
        assert 'text/javascript', @response.content_type
        assert_match(/Element\.show\("value_observed"\);/, @response.body)
      end
      
      should "render a list of observable values for the value observed form element if the observation has any" do
        observation = Observation.spawn
        observation.expects(:has_observable_values?).times(2).returns(true)
        Observation.expects(:find).with('1').returns(observation)
        get :on_observation_change, :observation_id => '1' 
        assert_response :success
        assert 'text/javascript', @response.content_type
        assert_match(/Element\.update\("value_observed_input", "<select/, @response.body)
      end
      
      should "render a text input field for the value observed form element if there are no observable values" do
        observation = Observation.spawn
        observation.expects(:has_observable_values?).times(2).returns(false)
        Observation.expects(:find).with('1').returns(observation)
        get :on_observation_change, :observation_id => '1' 
        assert_response :success
        assert 'text/javascript', @response.content_type
        assert_match(/Element\.update\("value_observed_input", "<input.*type=\\"text\\".*\);/, @response.body)
      end 
    end
    
    context "when a record is already present" do
      setup do
        @controller.instance_variable_set(:@record, RecordedObservation.new)
        observations = [
          Observation.spawn(:group => 'group_1', :name => 'obs_1' ),
          Observation.spawn(:group => 'group_1', :name => 'obs_2' ),
          Observation.spawn(:group => 'group_2', :name => 'obs_3' )
        ]
        observations.each_with_index { |obs, i| obs.id = i + 1 }
        Observation.expects(:all).returns(observations)

        get :new         
        
        assert_response :success
        assert_template 'create_form'
      end
      
      should_eventually "have the observation selected in the drop-down"
    end
    
    context "when 'create' action is called" do
      should "create a recorded observation recorded with an observable value" do
        observation = Observation.spawn
        observation.id = 1
        Observation.expects(:find).returns(observation)
        Observation.expects(:all).returns([])
        AquaticActivityEvent.stubs(:find).returns(nil)
        
        with_constraints :aquatic_activity_event_id => '2'
        post :create, :eid => eid, :record => { :observation => '1', :value_observed => '2' } 
      end
    end
  end
end
