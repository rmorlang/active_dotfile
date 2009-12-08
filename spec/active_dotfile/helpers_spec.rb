require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Test
  class Child1; end
  module Child2
    class Configuration
    end
  end
end

module ActiveDotfile
  describe Helpers do
    subject { ActiveDotfile::Helpers }
    describe "#default_dotfile_name_for" do
      it "should return the full class name converted to underscores" do
        subject.default_dotfile_name_for(Test::Child1.new).should == "test_child1"
      end

      it "should strip any config* suffix from the name" do
        subject.default_dotfile_name_for(Test::Child2::Configuration.new).should == "test_child2"
      end
    end
  end
end
