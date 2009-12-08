require 'active_dotfile/base'
require 'active_dotfile/configurable'
require 'active_dotfile/filename_helper'
require 'active_dotfile/helpers'

module ActiveDotfile
  def configuration
    class_name = ActiveDotfile::Helpers.underscore self.class.name
    @active_dotfile_configuration ||= ActiveDotfile::Base.new class_name
  end
end
