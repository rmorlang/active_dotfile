require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class IntegrationTestHelper
  include ActiveDotfile::Configurable
  load_dotfiles_on_initialize
  attr_accessor :param1, :param2
end

describe "integration" do
  before do
    filename_helper = mock("filename_helper")
    filename_helper.stub!(:configuration_files).and_return([ File.join(Dir.pwd, "spec/integration_dotfile") ])
    ActiveDotfile::FilenameHelper.stub!(:new).and_return(filename_helper)
  end

  subject { IntegrationTestHelper.new }
  it "should load param1 from the dotfile" do
    subject.param1.should == "foo"
  end
  it "should load param2 from the dotfile" do
    subject.param2.should == "bar"
  end
end
