# add active scaffold localizations
Globalite.add_localization_source(File.join(RAILS_ROOT, "lang", "active_scaffold"))
Globalite.add_localization_source(File.join(RAILS_ROOT, "lang", "rails"))

# override activescaffold's localization method
class Object
  def as_(string_to_localize, *args)
    unless string_to_localize.to_s.empty?
      lookup_key = string_to_localize.to_s.downcase.to_sym
      string_to_localize = lookup_key.l(string_to_localize) 
    end
    args.empty? ? string_to_localize : (sprintf string_to_localize, *args)
  end
end

# combine activescaffold and globalite method for error messages
module ActionView
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(*params)
        options = params.extract_options!.symbolize_keys
        if object = options.delete(:object)
          objects = [object].flatten
        else
          objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        end
        count   = objects.inject(0) {|sum, object| sum + object.errors.count }
        unless count.zero?
          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key]
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end

          options[:object_name] ||= params.first

          original_failed_object = options[:object_name].to_s.gsub('_', ' ')
          failed_object = options[:object_name].to_sym.l(original_failed_object)

          original_header_message = "#{pluralize(count, 'error')} prohibited this #{original_failed_object} from being saved"
          header_message = :active_record_helper_header_message.l_with_args({:error_count => count, :failed_object => failed_object }, original_header_message)
          message = :active_record_helper_error_description.l('There were problems with the following fields:')

          # Fix for :header_message and :message values if present
          # It works just like regular rails functionality
          options[:header_message] = header_message unless options.include?(:header_message)
          options[:message] =  message unless options.include?(:message)
          error_messages = objects.map {|object|
            object.errors.as_full_messages(active_scaffold_config).map {|msg| content_tag(:li, msg) }
          }

          contents = ''
          contents << content_tag(options[:header_tag] || :h2, options[:header_message]) unless options[:header_message].blank?
          contents << content_tag(:p, options[:message]) unless options[:message].blank?
          contents << content_tag(:ul, error_messages)

          content_tag(:div, contents, html)
        else
          ''
        end
      end
    end #module ActiveRecordHelper
  end #module Helpers
end #module ActionView