module Admin
  class UsersController < AdminController 
    helper do
      def area_of_interest_column(user)
        user.area_of_interest ? user.area_of_interest.drainage_cd : '-'
      end

      def language_column(user)
        case user.language
        when 'en' then 'English'
        when 'fr' then 'Français'
        end
      end
    end
    
    active_scaffold :user do |config|
      config.columns = [:name, :login, :email, :password, :password_confirmation, :agency, :area_of_interest, :language, :admin, :editor, :activated_at, :enabled, :last_login]
      config.list.columns = [:name, :login, :email, :agency, :language, :area_of_interest, :admin, :editor, :activated_at, :enabled, :last_login]
      config.create.columns = [:name, :login, :email, :password, :password_confirmation, :language, :agency, :admin, :editor]
      config.update.columns = [:name, :login, :email, :password, :password_confirmation, :language, :agency, :admin, :editor]
      
      config.columns[:language].form_ui = :select
      config.columns[:language].options = [['English', 'en'], ['Français', 'fr']]
      config.columns[:admin].form_ui = :checkbox
      config.columns[:editor].form_ui = :checkbox
      config.columns[:enabled].form_ui = :checkbox
    end
  end
end
