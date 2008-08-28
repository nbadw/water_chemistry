ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

class Test::Unit::TestCase  
  include AuthenticatedTestHelper  
  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true
  
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as_admin
    login_as User.generate!(:login => 'admin', :password => 'test', :password_confirmation => 'test')
  end
  
  def with_constraints(constraints = {}) 
    @request.session["as:#{eid}"] = { :constraints => constraints }
  end
  
  def eid
    'test_eid'
  end
end

module ThoughtBot
  module Shoulda 
    module ActiveRecord
      def should_use_table(table_name)
        klass = model_class
        should "use table #{table_name}" do
          assert_equal table_name.to_s, klass.table_name
        end
      end
      
      def should_use_primary_key(primary_key, options = nil)
        options = { :type => :integer, :null => false } unless options        
        klass = model_class
        should_have_db_column primary_key, options
        should "use primary key #{primary_key}" do
          assert_equal primary_key.to_s, klass.primary_key
        end
      end
      
      def should_define_timestamps
        should_define_attributes :imported_at, :exported_at, :created_at, :updated_at
      end
    
      def should_define_attributes(*attrs)
        attrs.each do |attr|      
          should_have_instance_methods attr, "#{attr}="
        end
      end
    
      def should_alias_attribute(old_attr, new_attr)
        old_getter, old_setter = old_attr, "#{old_attr}="
        new_getter, new_setter = new_attr, "#{new_attr}="
        
        should_have_instance_methods new_getter, new_setter
        
        model = model_class.new
        column = model.column_for_attribute(old_attr)
        old_value, new_value = case column.type
        when :integer  then [0, 1]
        when :float    then [0.1, 1.0]
        when :string   then ['old', 'new']
        when :boolean  then [true, false]
        when :datetime then [DateTime.now, DateTime.now + 1]
        end
        
        should "alias #{old_attr} as #{new_attr}" do
          model.send(old_setter, old_value)
          assert_equal(old_value, model.send(new_getter))
          model.send(new_setter, new_value)
          assert_equal(new_value, model.send(old_getter))
        end
      end
    end
  end
end
