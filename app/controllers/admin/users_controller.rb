module Admin
  class UsersController < AdminController 
    helper do
      def area_of_interest_column(user)
        user.area_of_interest ? user.area_of_interest.drainage_cd : '-'
      end
    end
    
    active_scaffold :user do |config|
      config.columns = [:name, :login, :email, :password, :password_confirmation, :agency, :area_of_interest, :admin, :editor, :activated_at, :enabled, :last_login]
      config.list.columns = [:name, :login, :email, :agency, :area_of_interest, :admin, :editor, :activated_at, :enabled, :last_login]
      config.create.columns = [:name, :login, :email, :password, :password_confirmation, :agency, :admin, :editor]
      config.update.columns = [:name, :login, :email, :password, :password_confirmation, :agency, :admin, :editor]
    end
  end
end
