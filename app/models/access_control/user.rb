# == Schema Information
# Schema version: 20081127150314
#
# Table name: users
#
#  id                           :integer(11)     not null, primary key
#  name                         :string(100)     
#  login                        :string(100)     
#  email                        :string(30)      
#  admin                        :boolean(1)      
#  editor                       :boolean(1)      
#  requesting_editor_priveleges :boolean(1)      
#  crypted_password             :string(40)      
#  salt                         :string(40)      
#  remember_token               :string(255)     
#  remember_token_expires_at    :datetime        
#  activation_code              :string(40)      
#  activated_at                 :datetime        
#  password_reset_code          :string(40)      
#  enabled                      :boolean(1)      default(TRUE)
#  agency_id                    :string(5)       
#  last_login                   :datetime        
#  created_at                   :datetime        
#  updated_at                   :datetime        
#  area_of_interest_id          :integer(11)
#  language                     :string(2)       default('en')
#

require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :name, :login, :email, :agency, :language
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_length_of       :name,     :within => 1..100
  validates_inclusion_of    :language, :in => %w(en fr)
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
  validates_associated      :agency
  
  belongs_to :agency
  belongs_to :area_of_interest, :class_name => 'Waterbody'
  
  before_save   :encrypt_password
  before_create :make_activation_code 
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :name, :login, :email, :password, :password_confirmation, 
    :agency_id, :agency, :admin, :area_of_interest, :area_of_interest_id, :language
  
  attr_accessor :requests_editor_priveleges
  alias_method  :requests_editor_priveleges?, :requests_editor_priveleges
  
  class ActivationCodeNotFound < StandardError  
  end

  class AlreadyActivated < StandardError
    attr_reader :user, :message
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end

  named_scope :administrators, :conditions => { :admin => true }

  # Finds the user with the corresponding activation code, activates their account and returns the user.
  #
  # Raises:
  #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
  #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
    raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
    raise ActivationCodeNotFound if !user
    raise AlreadyActivated.new(user) if user.active?
    user.send(:activate!)
    user
  end
  
  def active?
    # the presence of an activation date means they have activated
    !activated_at.nil?
  end
  
  def pending?
    !active?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  
  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end
  
  # used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def editor_priveleges_granted?
    @editor_priveleges_granted
  end

  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end

  def has_role?(rolename)
    self.roles.find_by_rolename(rolename) ? true : false
  end
  
  def before_save
    check_if_editor_priveleges_granted
  end
  
  protected  
  def check_if_editor_priveleges_granted
    # is this an existing record that had requested editor priveleges?
    return unless !new_record? && requesting_editor_priveleges?    
    # has the editor status changed?
    old_user = User.find(id)
    return unless old_user.editor? != editor?
    # set editor_priveleges_granted status to true if user is now an editor
    if editor?
      @editor_priveleges_granted = true
      write_attribute(:requesting_editor_priveleges, false)
    end 
    self
  end
  
  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = generate_salt if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def generate_salt
    Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
  end
      
  def password_required?
    crypted_password.blank? || !password.blank?
  end
    
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
    
  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  private   
  def activate!
    @activated = true
    self.update_attribute(:activated_at, Time.now.utc)
  end   
end
