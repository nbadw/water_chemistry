module DataWarehouse
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_incorporated(options = {})
      unless acts_as_incorporated? # don't let AR call this twice
        cattr_accessor :incorporated_attribute        
        self.incorporated_attribute = options[:with] || :incorporated_at
        include IncorporatedMethods
      end
    end
    
    def acts_as_incorporated?
      self.included_modules.include?(IncorporatedMethods)
    end
    
    def acts_as_importable(import_table = nil, options = {})
      unless acts_as_importable? # don't let AR call this twice
        cattr_accessor :import_from_table, :import_primary_key,
          :import_perform_validations, :import_must_import_all_or_fail                  
        self.import_from_table = import_table
        self.import_primary_key = options[:primary_key]
        self.import_perform_validations = options[:perform_validations] || false
        self.import_must_import_all_or_fail = option[:must_import_all_or_fail] || true
        include ImportMethods
      end
    end
    
    def acts_as_importable?
      self.included_modules.include?(ImportMethods)
    end
    
    def acts_as_exportable(options = {})
      unless acts_as_exportable? # don't let AR call this twice
        include ExportMethods
      end
    end
    
    def acts_as_exportable?
      self.included_modules.include?(ExportMethods)
    end
    
    def guess_target_attribute_column(target_attribute, possible_attributes, prefix = nil)
      weighted_levenshtein_distances = possible_attributes.collect do |possible_attribute|
        word1 = target_attribute.gsub('_', '')
        word2 = possible_attribute.gsub('_', '')
        word2.gsub!(prefix, '') if prefix
        distance = Text::Levenshtein.distance(word1, word2)        
        { :attribute => possible_attribute, :weight => (word1.length - distance).abs.to_f / word1.length.to_f }
      end.sort { |a,b| a[:weight] <=> b[:weight] } 

    end
    
  end  
end