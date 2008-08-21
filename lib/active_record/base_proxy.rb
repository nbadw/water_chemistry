# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module ActiveRecord
  module BaseProxy
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def find(*args)
        raise "You'll have to override the default find method implementation if you're including ActiveRecord::BaseProxy in this class"
      end
      
      def count(*args)
        raise "You'll have to override the default count method implementation if you're including ActiveRecord::BaseProxy in this class"       
      end
      
      def map(name, options = {})
        raise 'missing required parameter :class for map method' if options[:class].to_s.empty?
        raise 'missing required parameter :column for map method' if options[:column].to_s.empty?      
        @mappings = {} if @mappings.nil?
        @mappings[name.to_sym] = { :class => options[:class].to_s, :column => options[:column].to_s }
      end
    
      def mappings
        raise "you haven't declared any mappings yet!" if @mappings.nil?
        @mappings     
      end
    
      def columns
        if @columns.nil?   
          @columns = mappings.collect do |name, mapping|
            ar_klass = mapping[:class].constantize
            column = ar_klass.columns_hash[mapping[:column]]
            new_column = column.clone
            new_column.instance_variable_set(:@name, name)
            new_column     
          end
        end    
        @columns
      end
    
      # Generates all the attribute related methods for columns in the database
      # accessors, mutators and query methods.
      def define_attribute_methods
        return if generated_methods?      
      
        # define regular column attribute methods
        super
      
        # define the accessor methods for each mapped class instance
        mapped_klasses = []
        mappings.each { |name, mapping| mapped_klasses << mapping[:class] }
        mapped_klasses.uniq.each do |klass|
          instance_name = klass.underscore
          unless instance_method_already_implemented?(instance_name)
            define_mapped_instance_read_method(instance_name, klass)
          end
          unless instance_method_already_implemented?("#{instance_name}=")
            define_mapped_instance_write_method(instance_name)
          end
        end
      end
    
      def define_mapped_instance_read_method(instance_name, klass)
        method_name = "#{instance_name}"
        method_body = <<-EOV
        def #{method_name}
          @#{instance_name} ||= #{klass}.new
        end
        EOV
        define_mapped_instance_method(method_name, method_body)
      end
    
      def define_mapped_instance_write_method(instance_name)
        method_name = "#{instance_name}="
        method_body = <<-EOV
        def #{method_name}(value)
          @#{instance_name} = value
        end
        EOV
        define_mapped_instance_method(method_name, method_body)
      end
    
      def define_mapped_instance_method(method_name, method_definition)
        generated_methods << method_name  
        begin
          class_eval(method_definition, __FILE__, __LINE__)
        rescue SyntaxError => err
          generated_methods.delete(method_name)
          if logger
            logger.warn "Exception occurred during method compilation."
            logger.warn "Maybe #{method_name} is not a valid Ruby identifier?"
            logger.warn "#{err.message}"
          end
        end
      end
    
      # Define an attribute reader method.  Cope with nil column.
      def define_read_method(symbol, attr_name, column)   
        mapping = mappings[attr_name.to_sym]
        mapped_instance = mapping[:class].underscore  
        mapped_attr = mapping[:column]    
        evaluate_attribute_method attr_name, "def #{symbol}; #{mapped_instance}.#{mapped_attr}; end"
      end
    
      # Defines a predicate method <tt>attr_name?</tt>.
      def define_question_method(attr_name)  
        mapping = mappings[attr_name]
        mapped_instance = mapping[:class].underscore  
        mapped_attr = mapping[:column]
        evaluate_attribute_method attr_name, "def #{attr_name}?; #{mapped_instance}.#{mapped_attr}?; end", "#{attr_name}?"
      end

      def define_write_method(attr_name)    
        mapping = mappings[attr_name]
        mapped_instance = mapping[:class].underscore
        mapped_attr = mapping[:column]
        evaluate_attribute_method attr_name, "def #{attr_name}=(new_value); #{mapped_instance}.#{mapped_attr} = new_value; end", "#{attr_name}="
      end  
    end
  end
end
