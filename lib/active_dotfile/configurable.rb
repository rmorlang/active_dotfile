module ActiveDotfile
  module Configurable
    module InstanceMethods
      def configure
        yield self
      end    

      def load_configuration
        files = FilenameHelper.new(dotfile_name).configuration_files
        if files.empty?
          return false
        else
          files.each do |file|
            load file
          end
          return true
        end
      end

      def dotfile_name
        self.class.dotfile_name_value || Helpers.default_dotfile_name_for(self)
      end
    end

    module ClassMethods
      def dotfile_name(name)
        @dotfile_name = name
      end

      def dotfile_name_value
        @dotfile_name
      end

      def load_dotfiles_on_initialize
        return if instance_methods.include?(:initialize_without_dotfile_loading)
        class_eval <<-END_CODE
          def initialize_with_dotfile_loading(*args)
            initialize_without_dotfile_loading *args
            load_configuration
          end
          alias :initialize_without_dotfile_loading :initialize
          alias :initialize :initialize_with_dotfile_loading
        END_CODE
          
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
  end
end
