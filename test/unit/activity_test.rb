require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase
  should_require_attributes :name, :category
  
  context "given an existing activity record" do
    setup { @activity = Activity.generate }
    
    should_require_unique_attributes :name
  end
  
  context "given a set of activities" do
    setup do
      3.times { Activity.generate!(:category => 'category1') }
      2.times { Activity.generate!(:category => 'category2') }      
      Activity.generate!(:category => 'category3')
      
      assert_equal 6, Activity.count
      @grouped_activities = Activity.group_by_category(:all)
    end
    
    should "return three groups in total" do
      assert_equal 3, @grouped_activities.size 
    end
  end
end
