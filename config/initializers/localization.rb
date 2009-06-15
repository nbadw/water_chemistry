# add active scaffold localizations
Globalite.add_localization_source(File.join(RAILS_ROOT, "lang", "active_scaffold"))

# override active scaffold's localization method
class Object
  def as_(string_to_localize, *args)
    unless string_to_localize.to_s.empty?
      lookup_key = string_to_localize.downcase.to_sym
      string_to_localize = lookup_key.l(string_to_localize) 
    end
    args.empty? ? string_to_localize : (sprintf string_to_localize, *args)
  end
end
