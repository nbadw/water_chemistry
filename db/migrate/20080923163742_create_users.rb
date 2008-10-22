class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string     "name",                      :limit => 100
      t.string     "login",                     :limit => 100
      t.string     "email",                     :limit => 30
      t.boolean    "admin",                                   :default => false
      t.boolean    "editor",                                  :default => false
      t.string     "crypted_password",          :limit => 40
      t.string     "salt",                      :limit => 40
      t.string     "remember_token"
      t.timestamp  "remember_token_expires_at"
      t.string     "activation_code",           :limit => 40
      t.timestamp  "activated_at"
      t.string     "password_reset_code",       :limit => 40
      t.boolean    "enabled",                                 :default => true
      t.string     "agency_id",                 :limit => 5      
      t.timestamp  "last_login"
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
