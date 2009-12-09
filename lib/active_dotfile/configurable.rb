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
            eval File.read(file)
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

      # Like attr_accessor, except optionally with default values. Use hash syntax
      # to define a default value.
      #
      # Usage Example:
      #   attr_accessor_with_default :param1, :param2, :param3 => "default value", :param4 => "default"
      #
      def attr_accessor_with_default *args
        args.each do |arg|
          case arg
          when Symbol
            attr_accessor arg
          when Hash
            arg.each_pair do |method_name, value|
              # poached from ActiveSupport
              define_method(method_name, block_given? ? block : Proc.new { value })
              module_eval <<-EOM
                def #{method_name}=(value)
                  class << self
                    attr_reader :#{method_name} 
                  end
                  @#{method_name} = value
                end
              EOM
            end
          else
            raise "unknown argument to attr_accessor_with_default: #{arg.inspect}"
          end
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
  end
end
