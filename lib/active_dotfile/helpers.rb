module ActiveDotfile
  module Helpers
    # Helper functions used by ActiveDotfile. Code is put here to keep 
    # the namespaces clean.
    module_function

    # stolen from ActiveSupport :nodoc:
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    
    def default_dotfile_name_for(object)
      underscore(object.class.name).gsub("/","_").gsub(/_config[a-z]*$/,'')
    end
  end
end
