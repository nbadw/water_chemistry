require File.dirname(__FILE__) + '/../../test_helper'

class EnvironmentalPlanningTest < ActiveSupport::TestCase
  should_use_table "tblEnvironmentalPlanning"
  should_use_primary_key "EnvPlanningID"

  should_have_db_column "AquaticActivityID", :type => :integer
  should_have_db_column "IssueCategory", :limit => 50, :type => :string
  should_have_db_column "Issue", :limit => 250, :type => :string
  should_have_db_column "ActionRequired", :limit => 250, :type => :string
  should_have_db_column "ActionTargetDate", :type => :datetime
  should_have_db_column "ActionPriority", :type => :integer
  should_have_db_column "ActionCompletionDate", :type => :datetime
  should_have_db_column "FollowUpRequired", :type => :boolean
  should_have_db_column "FollowUpTargetDate", :type => :datetime
  should_have_db_column "FollowUpCompletionDate", :type => :datetime

  should_have_instance_methods :aquatic_activity_id, :issue_category, :issue,
    :action_required, :action_target_date, :action_priority, :action_completion_date,
    :follow_up_required, :follow_up_required?, :follow_up_target_date,
    :follow_up_completion_date
end
