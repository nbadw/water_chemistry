require File.dirname(__FILE__) + '/../test_helper'

class AquaticSiteControllerTest < ActionController::TestCase
  context "Aquatic Site Listing" do
    setup do
      login_as_admin
      get :list      
    end
    
    should_eventually "have label 'Data Collection Sites'" do
      doc = Hpricot(@response.body)
      assert_equal 1, doc.search("h2[text()='Data Collection Sites]").length
    end
  end
end
