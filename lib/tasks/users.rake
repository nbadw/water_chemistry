namespace :users do
  desc "creates an administrator account"
  task :create_admin => :environment do   
    admin_role = Role.create(:rolename => 'administrator')
    agency = Agency.find_by_code('ADW')
    
    admin = User.new
    admin.login = "admin"
    admin.email = "ccasey@unb.ca"
    admin.password = "colinfcasey"
    admin.password_confirmation = "colinfcasey"
    admin.agency = agency
    admin.save
    admin.send(:activate!)
        
    permission = Permission.new
    permission.role = admin_role
    permission.user = admin
    permission.save
  end
end