ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test/rails'
require 'test_help'

#def Object.path2class(klassname)
#  klassname.split('::').inject(Object) { |k,n| k.const_get n }
#end
#
#class FunctionalTestCase < Test::Unit::TestCase
#
#  def setup
#    self.class.name =~ /\ATest(.*)\Z/
#    return unless $1
#    controller_klass = Object.path2class $1
#    @controller = controller_klass.new
#    controller_klass.send(:define_method, :rescue_action) { |e| raise e }
#    @request = ActionController::TestRequest.new
#    @response = ActionController::TestResponse.new
#
#    @deliveries = []
#    ActionMailer::Base.deliveries = @deliveries
#  end
#
#  def test_stupid
#  end
#
#end

class Test::Rails::TestCase  
end
