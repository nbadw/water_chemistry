require File.dirname(__FILE__) + '/../test_helper'

class SiteMeasurementControllerTest < ActionController::TestCase
  context "on GET to :new" do
    setup do
      login_as_admin
      get :new
    end
    
    should_assign_to :measurements
  end
  
  context "on successful POST to :create" do
    setup do
      login_as_admin
      with_constraints :aquatic_site_id => AquaticSite.generate!.id, :aquatic_activity_event_id => AquaticActivityEvent.generate!.id
      post :create, :record => new_site_measurement, :eid => eid, :format => 'js'
    end
    
    should_render_template 'create.rjs'
    should_assign_to :record
    should_eventually("create the record successfully") { assert @controller.send(:successful?), assigns(:record).errors.full_messages.join(", ") }    
    should_eventually("perform an insert of the new record") { assert_select_rjs :insert, :top, "site_measurement-tbody" }
  end
  
  context "on failed POST to :create" do
    setup do 
      login_as_admin
      post :create, :record => {}, :format => 'js'
    end
    
    should_render_template 'create.rjs'
    should_render_a_form    
    should("fail to create the record") { assert !@controller.send(:successful?) }    
    should("replace current form with new one") { assert_select_rjs :replace, 'site_measurement-create--form' }
  end
  
  def new_site_measurement
    site_measurement = SiteMeasurement.spawn
    attributes = site_measurement.attributes
    [:instrument, :measurement, :unit_of_measure, :aquatic_site, :aquatic_activity_event].each do |association|
      site_measurement.send(association).save!
      attributes[association] = site_measurement.send(association).id
    end
    attributes.each { |k,v| attributes[k] = v.to_s }
  end
  
  def login_as_admin
    login_as User.generate!(:login => 'admin', :password => 'test', :password_confirmation => 'test')
  end
  
  def with_constraints(constraints = {}) 
    @request.session["as:#{eid}"] = { :constraints => constraints }
  end
  
  def eid
    'a0b1cde4f56789'
  end
end
