require 'project_scout'

module ActiveDotfile
  class FilenameHelper
    attr_accessor :name
    def initialize(name)
      self.name = name
    end

    def project_root_file
      existing_filename File.join(project_root, "." + name) if project_root
    end

    def home_directory_file
      existing_filename File.join(home_directory, "." + name)
    end

    def environment_file
      ENV[environment_key]
    end

    def configuration_files
      [ home_directory_file, project_root_file, environment_file ].compact
    end

    # :nodoc:
    def home_directory
      ENV["HOME"]
    end

    # :nodoc:
    def project_root
      ProjectScout.scan Dir.pwd 
    end

    # :nodoc:
    def existing_filename(path)
      return path if File.exists? path
    end

    # :nodoc:
    def environment_key
      name.upcase + "_CONFIG_FILE"
    end
  end
end
