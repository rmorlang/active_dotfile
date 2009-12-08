require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestClass
  include ActiveDotfile::Configurable
end

class TestClassWithInitializer
  include ActiveDotfile::Configurable
  load_dotfiles_on_initialize
end

module ActiveDotfile
  describe Configurable do
    describe "initialization" do
      it "should not load the configuration on init by default" do
        FilenameHelper.should_not_receive(:new)
        TestClass.new
      end

      it "should automatically load the configuration on init if so requested" do
        FilenameHelper.should_receive(:new).and_return(mock("filename_helper", :configuration_files => []))
        TestClassWithInitializer.new 
      end
    end

    describe "an instance using the module" do 
      before do
        TestClass.dotfile_name nil
      end
      subject { TestClass.new }
      describe "#load_configuration" do
        before do
          @filename_helper_mock = mock("FilenameHelper", :configuration_files => [])
          FilenameHelper.stub!(:new).and_return(@filename_helper_mock)
        end

        it "should initialize the filename helper with the dotfile name" do
          FilenameHelper.should_receive(:new).with("test_class").and_return(@filename_helper_mock)
          subject.load_configuration
        end

        it "should request a list of configuration files from the FilenameHelper" do
          @filename_helper_mock.should_receive(:configuration_files).and_return([])
          subject.load_configuration
        end

        it "should load each found configuration file and return true" do
          @filename_helper_mock.stub!(:configuration_files).and_return(["a", "b"])
          subject.should_receive(:load).with("a")
          subject.should_receive(:load).with("b")
          subject.load_configuration.should be_true
        end

        it "should return false if no configuration files" do
          subject.load_configuration.should be_false
        end
      end

      specify "#configure should yield the instance" do
        yielded_param = nil
        subject.configure do |param|
          yielded_param = param
        end
        yielded_param.should == subject
      end

      describe "#dotfile_name" do
        it "should return the user-set name if applicable" do
          TestClass.dotfile_name "foo"
          subject.dotfile_name.should == "foo"
        end

        it "should return the default name for the class if no user-set name" do
          Helpers.should_receive(:default_dotfile_name_for).with(subject).and_return("name")
          subject.dotfile_name.should == "name"
        end
      end
    end
  end
end