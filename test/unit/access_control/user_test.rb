require File.dirname(__FILE__) + '/../../test_helper'

class UserTest < Test::Unit::TestCase       
  should_require_attributes :name, :login, :email, :password, 
    :password_confirmation, :agency, :language
  
  should_ensure_length_in_range :password, (4..40)
  should_ensure_length_in_range :login, (3..40)
  should_ensure_length_in_range :email, (3..100)
  should_ensure_length_in_range :name, (1..100)
  should_allow_values_for :language, 'en', 'fr'

  
  should_belong_to :agency
  should_belong_to :area_of_interest
  
  should "create a valid User model from exemplar" do
    assert User.spawn.valid?
  end
  
  context "with a new user" do
    setup { @user = User.generate! }
    
    should_require_unique_attributes :login, :email
    
    should "set activation code after creation" do
      assert_not_nil @user.activation_code
    end
    
    should "be in pending status" do
      assert @user.pending?
    end    
    
    should "be able to set remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
    end

    should "be able to unset remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      @user.forget_me
      assert_nil @user.remember_token
    end
    
    should "remember me for one week" do
      before = 1.week.from_now.utc
      @user.remember_me_for 1.week
      after = 1.week.from_now.utc
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert @user.remember_token_expires_at.between?(before, after)
    end    

    should "remember me until one week has passed" do
      time = 1.week.from_now.utc
      @user.remember_me_until time
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert_equal @user.remember_token_expires_at, time
    end

    should "remember me for two weeks by default" do
      before = 2.weeks.from_now.utc
      @user.remember_me
      after = 2.weeks.from_now.utc
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert @user.remember_token_expires_at.between?(before, after)
    end  

    should "allow agency to be set" do
      a = Agency.generate!
      @user.agency = a
      assert_equal a.id, @user.agency_id
    end
  end
  
  context "with an activated user account" do
    setup do
      @user = User.generate!
      @user.update_attribute(:activated_at, DateTime.now)
      assert @user.active?
    end    
        
    should "be able to authenticate" do
      assert_equal @user, User.authenticate(@user.login, @user.password)
    end
          
    should "reset password after password change" do
      @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal @user, User.authenticate(@user.login, 'new password')
    end
      
    should "not rehash password after login name change" do
      @user.update_attributes(:login => 'newlogin')
      assert_equal @user, User.authenticate('newlogin', @user.password)
    end    
  end

end
