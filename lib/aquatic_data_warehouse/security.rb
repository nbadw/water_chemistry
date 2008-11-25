module AquaticDataWarehouse
  class RecordIsIncorporated < ActiveRecord::ActiveRecordError
  end  
  
  module Security    
    def self.included(base)
      base.before_destroy :ensure_record_is_not_incorporated
      base.extend(ClassMethods)
    end
    
    module ClassMethods      
      def acts_as_incorporated?
        !columns.detect { |column| column.name == 'IncorporatedInd' }.nil?
      end
    end 
    
    def incorporated?  
      if existing_record_check? && self.class.acts_as_incorporated?
        return !!incorporated_ind
      end
      
      return false
    end  
    
    def authorized_for_create?
      role_authorized_for_action?(:create)
    end
      
    def authorized_for_read?
      role_authorized_for_action?(:read)
    end
      
    def authorized_for_update?      
      role_authorized_for_action?(:update) && !incorporated?
    end
      
    def authorized_for_destroy?      
      role_authorized_for_action?(:destroy) && !incorporated?
    end
    
    def role_authorized_for_action?(action)            
      return false if current_user.nil? || current_user == :false
      authorization_method = "#{current_user_role}_user_authorized_for_#{action}?"      
      send(authorization_method)
    end
    
    def current_user_role
      if current_user.admin?
        :admin
      elsif current_user.editor?
        :editor
      else
        :public
      end
    end
    
    # CREATE PERMISSIONS
    def public_user_authorized_for_create?
      false
    end
    
    def admin_user_authorized_for_create?
      true
    end
    
    def editor_user_authorized_for_create?
      current_agency_authorized_for_create?
    end
    
    def current_agency_authorized_for_create?
      !!current_agency 
    end
    
    # READ PERMISSIONS        
    def public_user_authorized_for_read?
      true
    end
    
    def admin_user_authorized_for_read?
      true
    end
    
    def editor_user_authorized_for_read?
      true
    end
    
    def current_agency_authorized_for_read?
      !!current_agency 
    end
    
    # UPDATE PERMISSIONS
    def public_user_authorized_for_update?
      false
    end
    
    def admin_user_authorized_for_update?
      true
    end
    
    def editor_user_authorized_for_update?
      current_agency_authorized_for_update?
    end
    
    def current_agency_authorized_for_update?
      !!current_agency 
    end
    
    # DESTROY PERMISSIONS
    def public_user_authorized_for_destroy?
      false
    end
    
    def admin_user_authorized_for_destroy?
      true
    end
    
    def editor_user_authorized_for_destroy?
      current_agency_authorized_for_destroy?
    end
    
    def current_agency_authorized_for_destroy?
      !!current_agency 
    end
    
    private
    def ensure_record_is_not_incorporated
      raise(AquaticDataWarehouse::RecordIsIncorporated, "Incorporated records cannot be deleted") if incorporated?
    end
    
    module Access
      module Controller
        attr_reader :current_aquatic_site, 
          :current_aquatic_activity_event,
          :current_aquatic_site_usage
        
        def self.included(base)
          base.prepend_before_filter :execute_adw_access_variable_finders
          base.prepend_before_filter :make_adw_access_variable_available_to_models
        end
        
        def make_adw_access_variable_available_to_models
          assign_current_aquatic_site_to_models
          assign_current_aquatic_activity_event_to_models
          assign_current_aquatic_site_usage_to_models
          assign_current_agency_to_models
        end
                
        def assign_current_aquatic_site_to_models
          ActiveRecord::Base.current_aquatic_site_proc = proc { send(:current_aquatic_site) }
        end        
          
        def assign_current_aquatic_activity_event_to_models
          ActiveRecord::Base.current_aquatic_activity_event_proc = proc { send(:current_aquatic_activity_event) }
        end
                  
        def assign_current_aquatic_site_usage_to_models
          ActiveRecord::Base.current_aquatic_site_usage_proc = proc { send(:current_aquatic_site_usage) }
        end
        
        def assign_current_agency_to_models
          ActiveRecord::Base.current_agency_proc = proc { send(:current_agency) }
        end
        
        def current_agency
          current_user.agency if current_user && current_user != :false
        end
        
        def execute_adw_access_variable_finders
          find_current_aquatic_site
          find_current_aquatic_site_usage
          find_current_aquatic_activity_event
        end
                
        def find_current_aquatic_site; end
        def find_current_aquatic_site_usage; end
        def find_current_aquatic_activity_event; end
      end

      module Model
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          attr_accessor :current_aquatic_site_proc, 
            :current_aquatic_activity_event_proc, 
            :current_aquatic_site_usage_proc,
            :current_agency_proc
          
          def current_aquatic_site
            ActiveRecord::Base.current_aquatic_site_proc.call if ActiveRecord::Base.current_aquatic_site_proc
          end
          
          def current_aquatic_activity_event
            ActiveRecord::Base.current_aquatic_activity_event_proc.call if ActiveRecord::Base.current_aquatic_activity_event_proc
          end
          
          def current_aquatic_site_usage
            ActiveRecord::Base.current_aquatic_site_usage_proc.call if ActiveRecord::Base.current_aquatic_site_usage_proc
          end
          
          def current_agency
            ActiveRecord::Base.current_agency_proc.call if ActiveRecord::Base.current_agency_proc
          end
        end

        def current_aquatic_site
          self.class.current_aquatic_site
        end
        
        def current_aquatic_activity_event
          self.class.current_aquatic_activity_event
        end
        
        def current_aquatic_site_usage
          self.class.current_aquatic_site_usage
        end
        
        def current_agency
          self.class.current_agency
        end
      end
    end
  end
end

ActionController::Base.class_eval { include AquaticDataWarehouse::Security::Access::Controller }
ActiveRecord::Base.class_eval { include AquaticDataWarehouse::Security::Access::Model }
