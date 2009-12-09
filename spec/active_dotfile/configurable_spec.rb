require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestClass
  include ActiveDotfile::Configurable
  attr_accessor_with_default :no_default_value, :default_value => "default"
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
        File.stub! :read => ""
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
          File.should_receive(:read).with("a")
          File.should_receive(:read).with("b")
          subject.load_configuration.should be_true
        end

        it "should return false if no configuration files" do
          subject.load_configuration.should be_false
        end
      end

      describe "#attr_accessor_with_default" do
        describe "attributes with a default" do
          it "should return the default value when none other specified" do
            subject.default_value.should == "default"
          end

          it "should return the set value when one is specified" do
            subject.default_value = "something else"
            subject.default_value.should == "something else"
          end
        end

        describe "attributes without a default" do
          it "should return nil when no other value specified" do
            subject.no_default_value.should be_nil
          end

          it "should return the set value when one is specified" do
            subject.no_default_value = "something"
            subject.no_default_value.should == "something"
          end
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
